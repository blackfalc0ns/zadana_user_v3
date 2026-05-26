import 'package:zadana_user_v3/feature/notifications/data/models/notification_action_response_dto.dart';
import 'package:zadana_user_v3/feature/notifications/data/models/notification_device_preferences_request_dto.dart';
import 'package:zadana_user_v3/feature/notifications/data/models/notification_devices_response_dto.dart';
import 'package:zadana_user_v3/feature/notifications/data/models/notification_preferences_dto.dart';
import 'package:zadana_user_v3/feature/notifications/data/models/notification_unread_count_dto.dart';
import 'package:zadana_user_v3/feature/notifications/data/models/notifications_page_dto.dart';
import 'package:zadana_user_v3/feature/notifications/data/models/register_notification_device_request_dto.dart';
import 'package:zadana_user_v3/feature/notifications/data/models/unregister_notification_device_request_dto.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/notifications_query_entity.dart';

abstract class NotificationsRemoteDataSource {
  Future<NotificationsPageDto> getNotifications(NotificationsQueryEntity query);

  Future<NotificationUnreadCountDto> getUnreadCount();

  Future<NotificationActionResponseDto> markAsRead(String notificationId);

  Future<NotificationActionResponseDto> markAllAsRead();

  Future<void> deleteNotification(String notificationId);

  Future<NotificationActionResponseDto> deleteAllNotifications();

  Future<NotificationPreferencesDto> getNotificationPreferences();

  Future<void> updateNotificationPreferences(Map<String, dynamic> body);

  Future<NotificationDevicesResponseDto> getDevices();

  Future<void> registerDevice(RegisterNotificationDeviceRequestDto request);

  Future<void> updateDevicePreferences(
    NotificationDevicePreferencesRequestDto request,
  );

  Future<NotificationActionResponseDto> unregisterDevice(
    UnregisterNotificationDeviceRequestDto request,
  );
}
