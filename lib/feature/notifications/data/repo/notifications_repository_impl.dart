import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/notifications/data/data_source/notifications_remote_data_source.dart';
import 'package:zadana_user_v3/feature/notifications/data/models/notification_device_preferences_request_dto.dart';
import 'package:zadana_user_v3/feature/notifications/data/models/register_notification_device_request_dto.dart';
import 'package:zadana_user_v3/feature/notifications/data/models/unregister_notification_device_request_dto.dart';
import 'package:zadana_user_v3/feature/notifications/data/services/notifications_signalr_service.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/app_notification_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/notification_device_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/notification_device_preferences_request_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/notifications_page_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/notifications_query_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/register_notification_device_request_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/unregister_notification_device_request_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/repo/notifications_repository.dart';

@Injectable(as: NotificationsRepository)
class NotificationsRepositoryImpl implements NotificationsRepository {
  const NotificationsRepositoryImpl(
    this._remoteDataSource,
    this._notificationsSignalRService,
  );

  final NotificationsRemoteDataSource _remoteDataSource;
  final NotificationsSignalRService _notificationsSignalRService;

  @override
  Future<ApiResult<NotificationsPageEntity>> getNotifications(
    NotificationsQueryEntity query,
  ) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getNotifications(query);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<int>> getUnreadCount() async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getUnreadCount();
      return response.count;
    });
  }

  @override
  Stream<AppNotificationEntity> watchRealtimeNotifications() {
    return _notificationsSignalRService.watchNotifications();
  }

  @override
  Future<ApiResult<void>> markAsRead(String notificationId) async {
    return safeApiCall(() async {
      await _remoteDataSource.markAsRead(notificationId);
    });
  }

  @override
  Future<ApiResult<void>> markAllAsRead() async {
    return safeApiCall(() async {
      await _remoteDataSource.markAllAsRead();
    });
  }

  @override
  Future<ApiResult<List<NotificationDeviceEntity>>> getDevices() async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getDevices();
      return response.items.map((item) => item.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<void>> registerDevice(
    RegisterNotificationDeviceRequestEntity request,
  ) async {
    return safeApiCall(() async {
      await _remoteDataSource.registerDevice(
        RegisterNotificationDeviceRequestDto.fromEntity(request),
      );
    });
  }

  @override
  Future<ApiResult<void>> updateDevicePreferences(
    NotificationDevicePreferencesRequestEntity request,
  ) async {
    return safeApiCall(() async {
      await _remoteDataSource.updateDevicePreferences(
        NotificationDevicePreferencesRequestDto.fromEntity(request),
      );
    });
  }

  @override
  Future<ApiResult<void>> unregisterDevice(
    UnregisterNotificationDeviceRequestEntity request,
  ) async {
    return safeApiCall(() async {
      await _remoteDataSource.unregisterDevice(
        UnregisterNotificationDeviceRequestDto.fromEntity(request),
      );
    });
  }
}
