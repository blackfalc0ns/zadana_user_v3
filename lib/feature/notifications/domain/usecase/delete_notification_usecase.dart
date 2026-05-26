import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/notifications/domain/repo/notifications_repository.dart';

@injectable
class DeleteNotificationUseCase {
  const DeleteNotificationUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<ApiResult<void>> call(String notificationId) {
    return _repository.deleteNotification(notificationId);
  }
}
