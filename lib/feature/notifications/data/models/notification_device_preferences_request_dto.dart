import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/notification_device_preferences_request_entity.dart';

part 'notification_device_preferences_request_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class NotificationDevicePreferencesRequestDto {
  const NotificationDevicePreferencesRequestDto({
    this.deviceId,
    this.deviceToken,
    required this.notificationsEnabled,
  });

  factory NotificationDevicePreferencesRequestDto.fromJson(
    Map<String, dynamic> json,
  ) => _$NotificationDevicePreferencesRequestDtoFromJson(json);

  factory NotificationDevicePreferencesRequestDto.fromEntity(
    NotificationDevicePreferencesRequestEntity entity,
  ) {
    return NotificationDevicePreferencesRequestDto(
      deviceId: entity.deviceId,
      deviceToken: entity.deviceToken,
      notificationsEnabled: entity.notificationsEnabled,
    );
  }

  final String? deviceId;
  final String? deviceToken;
  final bool notificationsEnabled;

  Map<String, dynamic> toJson() =>
      _$NotificationDevicePreferencesRequestDtoToJson(this);
}
