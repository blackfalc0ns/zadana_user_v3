import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/core/services/app_navigator_service.dart';
import 'package:zadana_user_v3/core/services/push_notification_service.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/app_notification_entity.dart';

@lazySingleton
class LocalNotificationService {
  LocalNotificationService(this._appNavigatorService);

  final AppNavigatorService _appNavigatorService;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId =
      PushNotificationService.androidHeadsUpChannelId;
  static const String _channelName = 'Zadana Realtime Notifications';
  static const String _channelDescription =
      'Realtime notifications shown while the app is open';
  static const String _orderUpdatesChannelId =
      'zadana_order_updates_realtime_v2';
  static const String _orderUpdatesChannelName = 'Zadana Order Updates';
  static const String _orderUpdatesChannelDescription =
      'Heads-up alerts for live order status updates';

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _plugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.max,
      ),
    );
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _orderUpdatesChannelId,
        _orderUpdatesChannelName,
        description: _orderUpdatesChannelDescription,
        importance: Importance.max,
      ),
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

    await showSystemNotification(
      id: notification.id.hashCode,
      title: title.isEmpty ? body : title,
      body: body.isEmpty ? null : body,
      androidChannelId: _channelIdFor(notification),
      androidChannelName: _channelNameFor(notification),
      androidChannelDescription: _channelDescriptionFor(notification),
      payloadData: {
        'type': notification.type,
        'referenceId': notification.referenceId,
        'orderId': notification.dataObject?['orderId']?.toString(),
      },
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

  String _channelIdFor(AppNotificationEntity notification) {
    return notification.type == 'order_status_changed'
        ? _orderUpdatesChannelId
        : _channelId;
  }

  String _channelNameFor(AppNotificationEntity notification) {
    return notification.type == 'order_status_changed'
        ? _orderUpdatesChannelName
        : _channelName;
  }

  String _channelDescriptionFor(AppNotificationEntity notification) {
    return notification.type == 'order_status_changed'
        ? _orderUpdatesChannelDescription
        : _channelDescription;
  }

  Future<void> showPushNotification({
    required String title,
    String? body,
    Map<String, dynamic>? additionalData,
  }) async {
    final payload = additionalData ?? const <String, dynamic>{};
    final notificationType = payload['type']?.toString();
    final notificationId = payload['notificationId']?.toString().trim();
    final idSeed = (notificationId?.isNotEmpty ?? false)
        ? notificationId!
        : DateTime.now().microsecondsSinceEpoch.toString();

    await showSystemNotification(
      id: idSeed.hashCode,
      title: title,
      body: body,
      androidChannelId: _channelIdForType(notificationType),
      androidChannelName: _channelNameForType(notificationType),
      androidChannelDescription: _channelDescriptionForType(notificationType),
      payloadData: {
        'type': notificationType,
        'referenceId': payload['referenceId']?.toString(),
        'orderId': payload['orderId']?.toString(),
      },
    );
  }

  String _channelIdForType(String? notificationType) {
    return notificationType == 'order_status_changed'
        ? _orderUpdatesChannelId
        : _channelId;
  }

  String _channelNameForType(String? notificationType) {
    return notificationType == 'order_status_changed'
        ? _orderUpdatesChannelName
        : _channelName;
  }

  String _channelDescriptionForType(String? notificationType) {
    return notificationType == 'order_status_changed'
        ? _orderUpdatesChannelDescription
        : _channelDescription;
  }

  Future<void> _handleNotificationResponse(
    NotificationResponse response,
  ) async {
    final payload = response.payload;
    if (payload == null || payload.trim().isEmpty) {
      await _appNavigatorService.pushNamed(AppRoutes.notifications);
      return;
    }

    final decoded = jsonDecode(payload);
    if (decoded is! Map) {
      await _appNavigatorService.pushNamed(AppRoutes.notifications);
      return;
    }

    final type = decoded['type']?.toString();
    final orderId =
        decoded['referenceId']?.toString() ?? decoded['orderId']?.toString();

    switch (type) {
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
