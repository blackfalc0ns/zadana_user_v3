import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/notifications/domain/repo/notifications_repository.dart';

@injectable
class GetNotificationPreferencesUseCase {
  const GetNotificationPreferencesUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<ApiResult<Map<String, dynamic>>> call() {
    return _repository.getNotificationPreferences();
  }
}
