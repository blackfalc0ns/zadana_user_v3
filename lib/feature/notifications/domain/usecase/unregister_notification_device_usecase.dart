import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/unregister_notification_device_request_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/repo/notifications_repository.dart';

@injectable
class UnregisterNotificationDeviceUseCase {
  const UnregisterNotificationDeviceUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<ApiResult<void>> call(
    UnregisterNotificationDeviceRequestEntity request,
  ) {
    return _repository.unregisterDevice(request);
  }
}
