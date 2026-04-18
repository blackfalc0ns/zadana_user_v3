import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/notifications_page_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/notifications_query_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/repo/notifications_repository.dart';

@injectable
class GetNotificationsUseCase {
  const GetNotificationsUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<ApiResult<NotificationsPageEntity>> call(
    NotificationsQueryEntity query,
  ) {
    return _repository.getNotifications(query);
  }
}
