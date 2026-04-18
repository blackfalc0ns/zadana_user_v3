import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/unregister_notification_device_request_entity.dart';

part 'unregister_notification_device_request_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class UnregisterNotificationDeviceRequestDto {
  const UnregisterNotificationDeviceRequestDto({
    this.deviceId,
    this.deviceToken,
  });

  factory UnregisterNotificationDeviceRequestDto.fromJson(
    Map<String, dynamic> json,
  ) => _$UnregisterNotificationDeviceRequestDtoFromJson(json);

  factory UnregisterNotificationDeviceRequestDto.fromEntity(
    UnregisterNotificationDeviceRequestEntity entity,
  ) {
    return UnregisterNotificationDeviceRequestDto(
      deviceId: entity.deviceId,
      deviceToken: entity.deviceToken,
    );
  }

  final String? deviceId;
  final String? deviceToken;

  Map<String, dynamic> toJson() =>
      _$UnregisterNotificationDeviceRequestDtoToJson(this);
}
