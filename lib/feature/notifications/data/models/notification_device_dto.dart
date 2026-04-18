import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/notification_device_entity.dart';

part 'notification_device_dto.g.dart';

@JsonSerializable()
class NotificationDeviceDto {
  const NotificationDeviceDto({
    required this.id,
    this.deviceToken,
    this.platform,
    this.deviceId,
    this.deviceName,
    this.appVersion,
    this.locale,
    this.notificationsEnabled,
    this.isActive,
    this.lastRegisteredAtUtc,
    this.lastSeenAtUtc,
  });

  factory NotificationDeviceDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDeviceDtoFromJson(json);

  final String id;
  final String? deviceToken;
  final String? platform;
  final String? deviceId;
  final String? deviceName;
  final String? appVersion;
  final String? locale;
  final bool? notificationsEnabled;
  final bool? isActive;
  final String? lastRegisteredAtUtc;
  final String? lastSeenAtUtc;

  Map<String, dynamic> toJson() => _$NotificationDeviceDtoToJson(this);

  NotificationDeviceEntity toEntity() {
    return NotificationDeviceEntity(
      id: id,
      deviceToken: deviceToken,
      platform: platform,
      deviceId: deviceId,
      deviceName: deviceName,
      appVersion: appVersion,
      locale: locale,
      notificationsEnabled: notificationsEnabled ?? true,
      isActive: isActive ?? true,
      lastRegisteredAtUtc: DateTime.tryParse(lastRegisteredAtUtc ?? ''),
      lastSeenAtUtc: DateTime.tryParse(lastSeenAtUtc ?? ''),
    );
  }
}
