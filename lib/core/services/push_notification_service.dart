// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/services/app_navigator_service.dart';
import 'package:zadana_user_v3/core/services/local_notification_service.dart';
import 'package:zadana_user_v3/core/services/notification_device_service.dart';
import 'package:zadana_user_v3/core/services/notification_payload_resolver.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/notifications/data/services/notifications_signalr_service.dart';

class PushNotificationService {
  static const String _appId = "e557da4e-947b-468b-ab5b-37c552c35dca";
  static const String androidHeadsUpChannelId = "zadana_heads_up_notifications";
  static final Logger _logger = Logger();
  static bool _isInitialized = false;
  static Future<void>? _initializationFuture;
  static const Duration _overlayDuration = Duration(seconds: 3);
  static const Duration _overlayGap = Duration(milliseconds: 250);
  static const Duration _overlayContextRetryDelay = Duration(milliseconds: 200);
  static const int _overlayContextRetryAttempts = 15;
  static final ListQueue<Map<String, dynamic>> _foregroundOverlayQueue =
      ListQueue<Map<String, dynamic>>();
  static bool _isProcessingForegroundOverlayQueue = false;

  static Future<void> init() async {
    if (_isInitialized) {
      return;
    }

    final inFlightInitialization = _initializationFuture;
    if (inFlightInitialization != null) {
      await inFlightInitialization;
      return;
    }

    _initializationFuture = _initializeSdk();
    await _initializationFuture;
  }

  static Future<void> _initializeSdk() async {
    try {
      // Remove this method to stop OneSignal Debugging
      // OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

      await OneSignal.initialize(_appId);

      OneSignal.Notifications.addPermissionObserver((permission) {
        _logger.i('Notification permission changed: $permission');
      });

      OneSignal.User.pushSubscription.addObserver((state) async {
        final token = state.current.token;
        final subscriptionId = state.current.id;
        _logger.i(
          'Push subscription changed. id: $subscriptionId, token exists: ${token != null && token.isNotEmpty}',
        );
        await _cachePushTokenIfAvailable(token);
      });

      OneSignal.Notifications.addForegroundWillDisplayListener((event) async {
        final additionalData = event.notification.additionalData;
        final normalizedData = NotificationPayloadResolver.normalize(
          additionalData != null
              ? Map<String, dynamic>.from(additionalData)
              : <String, dynamic>{},
        );
        _logger.i(
          'OneSignal push received in foreground. '
          '${NotificationPayloadResolver.resolveDebugSummary(normalizedData, title: event.notification.title, body: event.notification.body)}',
        );
        getIt<NotificationsSignalRService>().ingestExternalOrderRelatedPayload(
          normalizedData,
          source: 'onesignal_foreground',
        );
        final displayContent =
            NotificationPayloadResolver.resolveDisplayContent(
              payload: normalizedData,
              title: event.notification.title,
              body: event.notification.body,
            );

        if (!displayContent.hasVisibleContent) {
          _logger.w(
            'Foreground notification arrived without visible title/body. '
            'This payload will not produce a standard popup notification, '
            'and it also cannot be shown by the system in killed state. '
            '${NotificationPayloadResolver.resolveDebugSummary(normalizedData, title: event.notification.title, body: event.notification.body)}',
          );
          return;
        }

        event.preventDefault();

        await getIt<LocalNotificationService>().showPushNotification(
          title: displayContent.title,
          body: displayContent.body,
          additionalData: normalizedData,
        );
        normalizedData['_displayTitle'] = displayContent.title;
        normalizedData['_displayBody'] = displayContent.body ?? '';
        _foregroundOverlayQueue.add(normalizedData);
        unawaited(_processForegroundOverlayQueue());
        _logger.i(
          'OneSignal visible push displayed in foreground via local '
          'notification. '
          '${NotificationPayloadResolver.resolveDebugSummary(normalizedData, title: displayContent.title, body: displayContent.body)}',
        );
      });

      OneSignal.Notifications.addClickListener((event) {
        final additionalData = event.notification.additionalData;
        final normalizedData = NotificationPayloadResolver.normalize(
          additionalData != null
              ? Map<String, dynamic>.from(additionalData)
              : <String, dynamic>{},
        );
        _logger.i(
          'OneSignal push clicked. '
          '${NotificationPayloadResolver.resolveDebugSummary(normalizedData, title: event.notification.title, body: event.notification.body)}',
        );
        unawaited(_openNotificationTarget(normalizedData));
      });

      _logger.i("OneSignal initialized with ID: $_appId");
      _isInitialized = true;
    } catch (e, stackTrace) {
      _logger.e(
        "Error initializing OneSignal: $e",
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      if (!_isInitialized) {
        _initializationFuture = null;
      }
    }
  }

  static Future<void> activateAuthenticatedPushIfPossible() async {
    await init();
    if (!_isInitialized) {
      _logger.w(
        'Skipped authenticated push activation because OneSignal is not initialized.',
      );
      return;
    }

    final restored = await _restoreAuthenticatedUserIfAvailable();
    if (!restored) {
      _logger.i(
        'Skipped authenticated push activation because no stored session was found.',
      );
      return;
    }

    await _preparePushSubscription();
  }

  static Future<void> loginCustomer(String customerId) async {
    final normalizedCustomerId = customerId.trim();
    if (normalizedCustomerId.isEmpty) {
      _logger.w('Skipped OneSignal.login because customerId is empty.');
      return;
    }

    await getIt<TokenService>().saveCurrentUserId(normalizedCustomerId);
    await init();
    if (!_isInitialized) {
      _logger.w(
        'Skipped OneSignal.login because OneSignal failed to initialize.',
      );
      return;
    }

    try {
      await OneSignal.login(normalizedCustomerId);
      _logger.i(
        'OneSignal.login completed for customerId: $normalizedCustomerId',
      );
      await _preparePushSubscription();
    } catch (e) {
      _logger.e(
        'Failed to log in user to OneSignal for customerId: '
        '$normalizedCustomerId, error: $e',
      );
    }
  }

  static Future<void> logoutCustomer() async {
    await getIt<TokenService>().deleteCurrentUserId();

    if (!_isInitialized) {
      return;
    }

    try {
      await OneSignal.logout();
      _logger.i('OneSignal.logout completed successfully.');
    } catch (e) {
      _logger.e('Failed to log out user from OneSignal: $e');
    }
  }

  static Future<bool> _restoreAuthenticatedUserIfAvailable() async {
    final tokenService = getIt<TokenService>();
    final accessToken = await tokenService.getToken();
    final customerId = await tokenService.getCurrentUserId();

    if (accessToken == null ||
        accessToken.trim().isEmpty ||
        customerId == null ||
        customerId.trim().isEmpty) {
      return false;
    }

    try {
      await OneSignal.login(customerId);
      _logger.i('OneSignal restored session for customerId: $customerId');
      return true;
    } catch (e) {
      _logger.e(
        'Failed to restore OneSignal session for customerId: '
        '$customerId, error: $e',
      );
      return false;
    }
  }

  static Future<void> _preparePushSubscription() async {
    await OneSignal.User.pushSubscription.optIn();

    if (!OneSignal.Notifications.permission) {
      final permissionGranted = await OneSignal.Notifications.requestPermission(
        true,
      );
      _logger.i('Notification permission granted: $permissionGranted');
    } else {
      _logger.i('Notification permission already granted.');
    }

    await _cachePushTokenIfAvailable(OneSignal.User.pushSubscription.token);
  }

  static Future<void> _cachePushTokenIfAvailable(String? token) async {
    if (token == null || token.trim().isEmpty) {
      _logger.w('Push token is still unavailable.');
      return;
    }

    await getIt<NotificationDeviceService>().cachePushToken(token);
    _logger.i('Push token cached and synced with backend.');
  }

  static Future<void> _processForegroundOverlayQueue() async {
    if (_isProcessingForegroundOverlayQueue) return;

    _isProcessingForegroundOverlayQueue = true;
    try {
      while (_foregroundOverlayQueue.isNotEmpty) {
        final overlayContext = await _waitForOverlayContext();
        if (overlayContext == null) {
          _logger.w(
            'Foreground notification banner is waiting for a navigator context.',
          );
          return;
        }

        final payload = _foregroundOverlayQueue.removeFirst();
        _logger.i(
          'Displaying foreground in-app banner. '
          'type: ${payload['type']}, notificationId: ${payload['notificationId']}',
        );
        CustomSnackbar.showTopBanner(
          context: overlayContext,
          message: _foregroundOverlayMessage(payload),
          duration: _overlayDuration,
          onTap: () => _openNotificationTarget(payload),
        );

        await Future<void>.delayed(_overlayDuration + _overlayGap);
      }
    } finally {
      _isProcessingForegroundOverlayQueue = false;
      if (_foregroundOverlayQueue.isNotEmpty) {
        unawaited(_retryForegroundOverlayQueue());
      }
    }
  }

  static Future<void> _retryForegroundOverlayQueue() async {
    await Future<void>.delayed(_overlayContextRetryDelay);
    await _processForegroundOverlayQueue();
  }

  static Future<BuildContext?> _waitForOverlayContext() async {
    final navigatorService = getIt<AppNavigatorService>();

    for (var attempt = 0; attempt < _overlayContextRetryAttempts; attempt++) {
      final overlayContext =
          navigatorService.navigator?.overlay?.context ??
          navigatorService.currentContext;
      if (overlayContext != null) {
        return overlayContext;
      }

      await WidgetsBinding.instance.endOfFrame;
      await Future<void>.delayed(_overlayContextRetryDelay);
    }

    return null;
  }

  static String _foregroundOverlayMessage(Map<String, dynamic> payload) {
    final title = payload['_displayTitle']?.toString().trim() ?? '';
    final body = payload['_displayBody']?.toString().trim() ?? '';

    if (title.isEmpty) return body;
    if (body.isEmpty) return title;
    return '$title\n$body';
  }

  static Future<void> _openNotificationTarget(
    Map<String, dynamic> payload,
  ) async {
    final type = payload['type']?.toString();
    final orderId = NotificationPayloadResolver.resolveOrderId(payload);
    final caseId = NotificationPayloadResolver.resolveSupportCaseId(payload);
    final appNavigatorService = getIt<AppNavigatorService>();

    if (NotificationPayloadResolver.isSupportCaseType(type) &&
        orderId != null &&
        orderId.isNotEmpty) {
      await appNavigatorService.pushNamedWhenReady(
        AppRoutes.orderSupportCase,
        arguments: {'orderId': orderId, 'caseId': caseId},
      );
      return;
    }

    if (NotificationPayloadResolver.isOrderRelatedType(type) &&
        orderId != null &&
        orderId.isNotEmpty) {
      await appNavigatorService.pushNamedWhenReady(
        AppRoutes.trackOrder,
        arguments: {'orderId': orderId},
      );
      return;
    }

    await appNavigatorService.pushNamedWhenReady(AppRoutes.notifications);
  }
}
