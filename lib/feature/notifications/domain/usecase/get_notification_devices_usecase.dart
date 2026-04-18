import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/notification_device_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/repo/notifications_repository.dart';

@injectable
class GetNotificationDevicesUseCase {
  const GetNotificationDevicesUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<ApiResult<List<NotificationDeviceEntity>>> call() {
    return _repository.getDevices();
  }
}
