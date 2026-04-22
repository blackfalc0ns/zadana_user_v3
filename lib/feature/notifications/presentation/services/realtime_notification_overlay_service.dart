// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/core/services/app_navigator_service.dart';
import 'package:zadana_user_v3/core/services/local_notification_service.dart';
import 'package:zadana_user_v3/core/services/notification_device_service.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/app_notification_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/usecase/watch_realtime_notifications_usecase.dart';

@lazySingleton
class RealtimeNotificationOverlayService {
  RealtimeNotificationOverlayService(
    this._watchRealtimeNotificationsUseCase,
    this._notificationDeviceService,
    this._localNotificationService,
    this._appNavigatorService,
  );

  final WatchRealtimeNotificationsUseCase _watchRealtimeNotificationsUseCase;
  final NotificationDeviceService _notificationDeviceService;
  final LocalNotificationService _localNotificationService;
  final AppNavigatorService _appNavigatorService;
  final Logger _logger = Logger();
  static const Duration _overlayDuration = Duration(seconds: 3);
  static const Duration _overlayGap = Duration(milliseconds: 250);
  static const Duration _overlayContextRetryDelay = Duration(
    milliseconds: 200,
  );
  static const int _overlayContextRetryAttempts = 15;

  StreamSubscription<AppNotificationEntity>? _subscription;
  final ListQueue<AppNotificationEntity> _overlayQueue =
      ListQueue<AppNotificationEntity>();
  bool _isProcessingOverlayQueue = false;

  void startListening() {
    if (_subscription != null) return;

    _subscription = _watchRealtimeNotificationsUseCase().listen((notification) {
      unawaited(_showOverlayFor(notification));
    });
  }

  Future<void> _showOverlayFor(AppNotificationEntity notification) async {
    try {
      final isEnabled = await _notificationDeviceService
          .isNotificationsEnabled();
      if (isEnabled) {
        await _localNotificationService.showRealtimeNotification(notification);
      } else {
        _logger.i(
          'System notifications are disabled, showing in-app banner only for '
          '${notification.type ?? notification.id}.',
        );
      }
      _overlayQueue.add(notification);
      unawaited(_processInAppOverlayQueue());
      _logger.i(
        'Realtime notification queued for banner display: '
        '${notification.type ?? notification.id}.',
      );
    } catch (error, stackTrace) {
      _logger.e(
        'Failed to show realtime local notification.',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _processInAppOverlayQueue() async {
    if (_isProcessingOverlayQueue) return;

    _isProcessingOverlayQueue = true;
    try {
      while (_overlayQueue.isNotEmpty) {
        final overlayContext = await _waitForOverlayContext();
        if (overlayContext == null) {
          _logger.w('Realtime banner is waiting for a navigator context.');
          return;
        }

        final notification = _overlayQueue.removeFirst();
        _logger.i(
          'Displaying realtime in-app banner for '
          '${notification.type ?? notification.id}.',
        );
        CustomSnackbar.showTopBanner(
          context: overlayContext,
          message: _overlayMessageFor(notification),
          duration: _overlayDuration,
          onTap: () => _openNotificationTarget(notification),
        );

        await Future<void>.delayed(_overlayDuration + _overlayGap);
      }
    } finally {
      _isProcessingOverlayQueue = false;
      if (_overlayQueue.isNotEmpty) {
        unawaited(_retryOverlayQueue());
      }
    }
  }

  Future<void> _retryOverlayQueue() async {
    await Future<void>.delayed(_overlayContextRetryDelay);
    await _processInAppOverlayQueue();
  }

  Future<BuildContext?> _waitForOverlayContext() async {
    for (var attempt = 0; attempt < _overlayContextRetryAttempts; attempt++) {
      final overlayContext =
          _appNavigatorService.navigator?.overlay?.context ??
          _appNavigatorService.currentContext;
      if (overlayContext != null) {
        return overlayContext;
      }

      await WidgetsBinding.instance.endOfFrame;
      await Future<void>.delayed(_overlayContextRetryDelay);
    }

    return null;
  }

  String _overlayMessageFor(AppNotificationEntity notification) {
    final title = notification.titleAr.trim().isNotEmpty
        ? notification.titleAr.trim()
        : notification.titleEn.trim();
    final body = notification.bodyAr.trim().isNotEmpty
        ? notification.bodyAr.trim()
        : notification.bodyEn.trim();

    if (title.isEmpty) return body;
    if (body.isEmpty) return title;
    return '$title\n$body';
  }

  Future<void> _openNotificationTarget(
    AppNotificationEntity notification,
  ) async {
    final orderId = notification.referenceId?.trim().isNotEmpty == true
        ? notification.referenceId!.trim()
        : notification.dataObject?['orderId']?.toString();

    switch (notification.type) {
      case 'order_status_changed':
      case 'order_cancelled':
      case 'order_placed':
        if (orderId != null && orderId.isNotEmpty) {
          await _appNavigatorService.pushNamed(
            AppRoutes.trackOrder,
            arguments: {'orderId': orderId},
          );
          return;
        }
      default:
        await _appNavigatorService.pushNamed(AppRoutes.notifications);
    }
  }
}
