import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/register_notification_device_request_entity.dart';

part 'register_notification_device_request_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class RegisterNotificationDeviceRequestDto {
  const RegisterNotificationDeviceRequestDto({
    required this.deviceToken,
    required this.platform,
    this.deviceId,
    this.deviceName,
    this.appVersion,
    this.locale,
    this.notificationsEnabled,
  });

  factory RegisterNotificationDeviceRequestDto.fromJson(
    Map<String, dynamic> json,
  ) => _$RegisterNotificationDeviceRequestDtoFromJson(json);

  factory RegisterNotificationDeviceRequestDto.fromEntity(
    RegisterNotificationDeviceRequestEntity entity,
  ) {
    return RegisterNotificationDeviceRequestDto(
      deviceToken: entity.deviceToken,
      platform: entity.platform,
      deviceId: entity.deviceId,
      deviceName: entity.deviceName,
      appVersion: entity.appVersion,
      locale: entity.locale,
      notificationsEnabled: entity.notificationsEnabled,
    );
  }

  final String deviceToken;
  final String platform;
  final String? deviceId;
  final String? deviceName;
  final String? appVersion;
  final String? locale;
  final bool? notificationsEnabled;

  Map<String, dynamic> toJson() =>
      _$RegisterNotificationDeviceRequestDtoToJson(this);
}
