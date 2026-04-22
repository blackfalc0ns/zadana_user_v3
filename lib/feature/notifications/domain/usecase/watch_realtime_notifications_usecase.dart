import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/app_notification_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/repo/notifications_repository.dart';

@injectable
class WatchRealtimeNotificationsUseCase {
  const WatchRealtimeNotificationsUseCase(this._repository);

  final NotificationsRepository _repository;

  Stream<AppNotificationEntity> call() {
    return _repository.watchRealtimeNotifications();
  }
}
