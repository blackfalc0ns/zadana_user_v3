import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/core/utils/localized_api_message.dart';

part 'notification_action_response_dto.g.dart';

@JsonSerializable()
class NotificationActionResponseDto {
  const NotificationActionResponseDto({this.message, this.count});

  factory NotificationActionResponseDto.fromJson(Map<String, dynamic> json) =>
      NotificationActionResponseDto(
        message: resolveLocalizedApiMessage(json),
        count: json['count'] as int?,
      );

  final String? message;
  final int? count;

  Map<String, dynamic> toJson() => _$NotificationActionResponseDtoToJson(this);
}
