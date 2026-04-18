import 'package:zadana_user_v3/feature/notifications/domain/entities/app_notification_entity.dart';

class NotificationsPageEntity {
  const NotificationsPageEntity({
    required this.items,
    required this.page,
    required this.perPage,
    required this.total,
    required this.unreadCount,
    required this.hasMore,
  });

  final List<AppNotificationEntity> items;
  final int page;
  final int perPage;
  final int total;
  final int unreadCount;
  final bool hasMore;
}
