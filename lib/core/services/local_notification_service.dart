import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/core/services/app_navigator_service.dart';
import 'package:zadana_user_v3/core/services/notification_deduplicator.dart';
import 'package:zadana_user_v3/core/services/notification_payload_resolver.dart';
import 'package:zadana_user_v3/core/services/push_notification_service.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/app_notification_entity.dart';

@lazySingleton
class LocalNotificationService {
  LocalNotificationService(
    this._appNavigatorService,
    this._deduplicator,
  );

  final AppNavigatorService _appNavigatorService;
  final NotificationDeduplicator _deduplicator;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId =
      PushNotificationService.androidHeadsUpChannelId;
  static const String _channelName = 'Order updates';
  static const String _channelDescription =
      'Heads-up alerts for order and account updates.';

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_stat_onesignal_default'),
      iOS: DarwinInitializationSettings(),
    );

    await _plugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );

    _isInitialized = true;
  }

  Future<void> showRealtimeNotification(
    AppNotificationEntity notification,
  ) async {
    final title = notification.titleAr.trim().isNotEmpty
        ? notification.titleAr.trim()
        : notification.titleEn.trim();
    final body = notification.bodyAr.trim().isNotEmpty
        ? notification.bodyAr.trim()
        : notification.bodyEn.trim();

    if (title.isEmpty && body.isEmpty) return;

    final payload = _payloadDataFromNotification(notification);
    final orderId = NotificationPayloadResolver.resolveOrderId(payload);
    final status = NotificationPayloadResolver.resolveStatus(payload);
    final systemId = _deduplicator.resolveSystemNotificationId(
      notificationId: notification.id,
      orderId: orderId,
      status: status,
      type: notification.type,
      title: title,
      body: body,
    );

    await showSystemNotification(
      id: systemId,
      title: title.isEmpty ? body : title,
      body: body.isEmpty ? null : body,
      androidChannelId: _channelId,
      androidChannelName: _channelName,
      androidChannelDescription: _channelDescription,
      payloadData: payload,
    );
  }

  Future<void> showSystemNotification({
    required int id,
    required String title,
    String? body,
    String? androidChannelId,
    String? androidChannelName,
    String? androidChannelDescription,
    Map<String, dynamic>? payloadData,
  }) async {
    await init();

    if (title.trim().isEmpty && (body == null || body.trim().isEmpty)) {
      return;
    }

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          androidChannelId ?? _channelId,
          androidChannelName ?? _channelName,
          channelDescription: androidChannelDescription ?? _channelDescription,
          importance: Importance.max,
          priority: Priority.max,
          icon: '@drawable/ic_stat_onesignal_default',
          color: AppColors.primary,
          category: AndroidNotificationCategory.message,
          ticker: 'zadana_realtime_notification',
          visibility: NotificationVisibility.public,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(payloadData ?? const <String, dynamic>{}),
    );
  }

  Future<void> showPushNotification({
    required String title,
    String? body,
    Map<String, dynamic>? additionalData,
  }) async {
    final payload = _payloadDataFromAdditionalData(additionalData ?? const <String, dynamic>{});
    final notificationId = payload['notificationId']?.toString().trim();
    final orderId = NotificationPayloadResolver.resolveOrderId(payload);
    final status = NotificationPayloadResolver.resolveStatus(payload);
    final systemId = _deduplicator.resolveSystemNotificationId(
      notificationId: notificationId,
      orderId: orderId,
      status: status,
      type: payload['type']?.toString(),
      title: title,
      body: body,
    );

    await showSystemNotification(
      id: systemId,
      title: title,
      body: body,
      androidChannelId: _channelId,
      androidChannelName: _channelName,
      androidChannelDescription: _channelDescription,
      payloadData: payload,
    );
  }

  Map<String, dynamic> _payloadDataFromNotification(
    AppNotificationEntity notification,
  ) {
    final payload = notification.dataObject != null
        ? Map<String, dynamic>.from(notification.dataObject!)
        : <String, dynamic>{};

    payload['type'] = notification.type;
    payload['referenceId'] = notification.referenceId;
    return NotificationPayloadResolver.normalize(payload);
  }

  Map<String, dynamic> _payloadDataFromAdditionalData(
    Map<String, dynamic> additionalData,
  ) {
    return NotificationPayloadResolver.normalize(additionalData);
  }

  Future<void> _handleNotificationResponse(
    NotificationResponse response,
  ) async {
    final payload = response.payload;
    if (payload == null || payload.trim().isEmpty) {
      await _appNavigatorService.pushNamedWhenReady(AppRoutes.notifications);
      return;
    }

    final decoded = jsonDecode(payload);
    if (decoded is! Map) {
      await _appNavigatorService.pushNamedWhenReady(AppRoutes.notifications);
      return;
    }

    final normalizedPayload = NotificationPayloadResolver.normalize(
      Map<String, dynamic>.from(decoded),
    );
    final type = normalizedPayload['type']?.toString();
    final orderId = NotificationPayloadResolver.resolveOrderId(
      normalizedPayload,
    );
    final caseId = NotificationPayloadResolver.resolveSupportCaseId(
      normalizedPayload,
    );

    if (NotificationPayloadResolver.isSupportCaseType(type) &&
        orderId != null &&
        orderId.isNotEmpty) {
      await _appNavigatorService.pushNamedWhenReady(
        AppRoutes.orderSupportCase,
        arguments: {'orderId': orderId, 'caseId': caseId},
      );
      return;
    }

    if (NotificationPayloadResolver.isOrderRelatedType(type) &&
        orderId != null &&
        orderId.isNotEmpty) {
      await _appNavigatorService.pushNamedWhenReady(
        NotificationPayloadResolver.shouldOpenOrderTracking(type)
            ? AppRoutes.trackOrder
            : AppRoutes.orderDetails,
        arguments: {'orderId': orderId},
      );
      return;
    }

    await _appNavigatorService.pushNamedWhenReady(AppRoutes.notifications);
  }
}
