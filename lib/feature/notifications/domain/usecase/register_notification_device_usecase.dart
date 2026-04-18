import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/register_notification_device_request_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/repo/notifications_repository.dart';

@injectable
class RegisterNotificationDeviceUseCase {
  const RegisterNotificationDeviceUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<ApiResult<void>> call(
    RegisterNotificationDeviceRequestEntity request,
  ) {
    return _repository.registerDevice(request);
  }
}
