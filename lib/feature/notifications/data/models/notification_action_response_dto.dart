import 'package:json_annotation/json_annotation.dart';

part 'notification_action_response_dto.g.dart';

@JsonSerializable()
class NotificationActionResponseDto {
  const NotificationActionResponseDto({this.message, this.count});

  factory NotificationActionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationActionResponseDtoFromJson(json);

  final String? message;
  final int? count;

  Map<String, dynamic> toJson() => _$NotificationActionResponseDtoToJson(this);
}
