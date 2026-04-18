import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/feature/notifications/data/data_source/notifications_remote_data_source.dart';
import 'package:zadana_user_v3/feature/notifications/data/models/notification_action_response_dto.dart';
import 'package:zadana_user_v3/feature/notifications/data/models/notification_device_preferences_request_dto.dart';
import 'package:zadana_user_v3/feature/notifications/data/models/notification_devices_response_dto.dart';
import 'package:zadana_user_v3/feature/notifications/data/models/notification_unread_count_dto.dart';
import 'package:zadana_user_v3/feature/notifications/data/models/notifications_page_dto.dart';
import 'package:zadana_user_v3/feature/notifications/data/models/register_notification_device_request_dto.dart';
import 'package:zadana_user_v3/feature/notifications/data/models/unregister_notification_device_request_dto.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/notifications_query_entity.dart';

@Injectable(as: NotificationsRemoteDataSource)
class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  const NotificationsRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<NotificationsPageDto> getNotifications(NotificationsQueryEntity query) {
    return _apiServices.getNotifications(
      query.page,
      query.perPage,
      query.type,
      query.isRead,
      query.fromUtc?.toUtc().toIso8601String(),
      query.toUtc?.toUtc().toIso8601String(),
    );
  }

  @override
  Future<NotificationUnreadCountDto> getUnreadCount() {
    return _apiServices.getNotificationsUnreadCount();
  }

  @override
  Future<NotificationActionResponseDto> markAsRead(String notificationId) {
    return _apiServices.markNotificationAsRead(notificationId);
  }

  @override
  Future<NotificationActionResponseDto> markAllAsRead() {
    return _apiServices.markAllNotificationsAsRead();
  }

  @override
  Future<NotificationDevicesResponseDto> getDevices() {
    return _apiServices.getNotificationDevices();
  }

  @override
  Future<void> registerDevice(RegisterNotificationDeviceRequestDto request) {
    return _apiServices.registerNotificationDevice(request);
  }

  @override
  Future<void> updateDevicePreferences(
    NotificationDevicePreferencesRequestDto request,
  ) {
    return _apiServices.updateNotificationDevicePreferences(request);
  }

  @override
  Future<NotificationActionResponseDto> unregisterDevice(
    UnregisterNotificationDeviceRequestDto request,
  ) {
    return _apiServices.unregisterNotificationDevice(request);
  }
}
