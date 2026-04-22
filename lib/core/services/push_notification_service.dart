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
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';

class PushNotificationService {
  static const String _appId = "e557da4e-947b-468b-ab5b-37c552c35dca";
  static const String androidHeadsUpChannelId = "zadana_heads_up_notifications";
  static final Logger _logger = Logger();
  static bool _isInitialized = false;
  static const Duration _overlayDuration = Duration(seconds: 3);
  static const Duration _overlayGap = Duration(milliseconds: 250);
  static const Duration _overlayContextRetryDelay = Duration(
    milliseconds: 200,
  );
  static const int _overlayContextRetryAttempts = 15;
  static final ListQueue<Map<String, dynamic>> _foregroundOverlayQueue =
      ListQueue<Map<String, dynamic>>();
  static bool _isProcessingForegroundOverlayQueue = false;

  static Future<void> init() async {
    if (_isInitialized) {
      _logger.w('PushNotificationService.init() was called more than once.');
      return;
    }

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
        final title = event.notification.title?.trim();
        final body = event.notification.body?.trim();
        final hasVisibleContent =
            (title?.isNotEmpty ?? false) || (body?.isNotEmpty ?? false);
        final additionalData = event.notification.additionalData;
        final normalizedData = additionalData != null
            ? Map<String, dynamic>.from(additionalData)
            : <String, dynamic>{};

        if (!hasVisibleContent) {
          _logger.w(
            'Foreground notification arrived without visible title/body. '
            'This payload will not produce a standard popup notification. '
            'data: $normalizedData',
          );
          return;
        }

        event.preventDefault();

        await getIt<LocalNotificationService>().showPushNotification(
          title: (title?.isNotEmpty ?? false) ? title! : body ?? '',
          body: (title?.isNotEmpty ?? false) ? body : null,
          additionalData: normalizedData,
        );
        normalizedData['_displayTitle'] = title ?? '';
        normalizedData['_displayBody'] = body ?? '';
        _foregroundOverlayQueue.add(normalizedData);
        unawaited(_processForegroundOverlayQueue());
        _logger.i(
          'Foreground notification displayed via local notification. '
          'title: ${title ?? '(empty)'}, body exists: ${body?.isNotEmpty ?? false}, '
          'type: ${normalizedData['type']}, notificationId: ${normalizedData['notificationId']}',
        );
      });

      OneSignal.Notifications.addClickListener((event) {
        _logger.i('Notification clicked: ${event.notification.additionalData}');
      });

      await _restoreAuthenticatedUserIfAvailable();
      await _preparePushSubscription();

      _logger.i("OneSignal initialized with ID: $_appId");
      _isInitialized = true;
    } catch (e) {
      _logger.e("Error initializing OneSignal: $e");
    }
  }

  static Future<void> loginCustomer(String customerId) async {
    final normalizedCustomerId = customerId.trim();
    if (normalizedCustomerId.isEmpty) {
      _logger.w('Skipped OneSignal.login because customerId is empty.');
      return;
    }

    await getIt<TokenService>().saveCurrentUserId(normalizedCustomerId);

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

  static Future<void> _restoreAuthenticatedUserIfAvailable() async {
    final tokenService = getIt<TokenService>();
    final accessToken = await tokenService.getToken();
    final customerId = await tokenService.getCurrentUserId();

    if (accessToken == null ||
        accessToken.trim().isEmpty ||
        customerId == null ||
        customerId.trim().isEmpty) {
      return;
    }

    try {
      await OneSignal.login(customerId);
      _logger.i('OneSignal restored session for customerId: $customerId');
    } catch (e) {
      _logger.e(
        'Failed to restore OneSignal session for customerId: '
        '$customerId, error: $e',
      );
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
    final orderId = payload['referenceId']?.toString().trim().isNotEmpty == true
        ? payload['referenceId']?.toString().trim()
        : payload['orderId']?.toString().trim();

    switch (type) {
      case 'order_status_changed':
      case 'order_cancelled':
      case 'order_placed':
        if (orderId != null && orderId.isNotEmpty) {
          await getIt<AppNavigatorService>().pushNamed(
            AppRoutes.trackOrder,
            arguments: {'orderId': orderId},
          );
          return;
        }
      default:
        await getIt<AppNavigatorService>().pushNamed(AppRoutes.notifications);
    }
  }
}
