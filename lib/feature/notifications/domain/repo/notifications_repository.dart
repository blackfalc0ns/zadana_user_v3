import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/app_notification_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/notification_device_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/notification_device_preferences_request_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/notifications_page_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/notifications_query_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/register_notification_device_request_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/unregister_notification_device_request_entity.dart';

abstract class NotificationsRepository {
  Future<ApiResult<NotificationsPageEntity>> getNotifications(
    NotificationsQueryEntity query,
  );

  Future<ApiResult<int>> getUnreadCount();

  Stream<AppNotificationEntity> watchRealtimeNotifications();

  Future<ApiResult<void>> markAsRead(String notificationId);

  Future<ApiResult<void>> markAllAsRead();

  Future<ApiResult<List<NotificationDeviceEntity>>> getDevices();

  Future<ApiResult<void>> registerDevice(
    RegisterNotificationDeviceRequestEntity request,
  );

  Future<ApiResult<void>> updateDevicePreferences(
    NotificationDevicePreferencesRequestEntity request,
  );

  Future<ApiResult<void>> unregisterDevice(
    UnregisterNotificationDeviceRequestEntity request,
  );
}
