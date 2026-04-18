import 'package:json_annotation/json_annotation.dart';

part 'notification_unread_count_dto.g.dart';

@JsonSerializable()
class NotificationUnreadCountDto {
  const NotificationUnreadCountDto({required this.count});

  factory NotificationUnreadCountDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationUnreadCountDtoFromJson(json);

  final int count;

  Map<String, dynamic> toJson() => _$NotificationUnreadCountDtoToJson(this);
}
