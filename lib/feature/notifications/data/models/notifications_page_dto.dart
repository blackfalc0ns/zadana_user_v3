import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/notifications/data/models/app_notification_dto.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/notifications_page_entity.dart';

part 'notifications_page_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class NotificationsPageDto {
  const NotificationsPageDto({
    required this.items,
    required this.page,
    required this.perPage,
    required this.total,
    required this.unreadCount,
    required this.hasMore,
  });

  factory NotificationsPageDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationsPageDtoFromJson(json);

  final List<AppNotificationDto> items;
  final int page;
  final int perPage;
  final int total;
  final int unreadCount;
  final bool hasMore;

  Map<String, dynamic> toJson() => _$NotificationsPageDtoToJson(this);

  NotificationsPageEntity toEntity() {
    return NotificationsPageEntity(
      items: items.map((item) => item.toEntity()).toList(),
      page: page,
      perPage: perPage,
      total: total,
      unreadCount: unreadCount,
      hasMore: hasMore,
    );
  }
}
