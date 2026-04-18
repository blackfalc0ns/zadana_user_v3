import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/notifications/domain/repo/notifications_repository.dart';

@injectable
class GetNotificationUnreadCountUseCase {
  const GetNotificationUnreadCountUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<ApiResult<int>> call() {
    return _repository.getUnreadCount();
  }
}
