// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_device_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationDeviceDto _$NotificationDeviceDtoFromJson(
  Map<String, dynamic> json,
) => NotificationDeviceDto(
  id: json['id'] as String,
  deviceToken: json['deviceToken'] as String?,
  platform: json['platform'] as String?,
  deviceId: json['deviceId'] as String?,
  deviceName: json['deviceName'] as String?,
  appVersion: json['appVersion'] as String?,
  locale: json['locale'] as String?,
  notificationsEnabled: json['notificationsEnabled'] as bool?,
  isActive: json['isActive'] as bool?,
  lastRegisteredAtUtc: json['lastRegisteredAtUtc'] as String?,
  lastSeenAtUtc: json['lastSeenAtUtc'] as String?,
);

Map<String, dynamic> _$NotificationDeviceDtoToJson(
  NotificationDeviceDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'deviceToken': instance.deviceToken,
  'platform': instance.platform,
  'deviceId': instance.deviceId,
  'deviceName': instance.deviceName,
  'appVersion': instance.appVersion,
  'locale': instance.locale,
  'notificationsEnabled': instance.notificationsEnabled,
  'isActive': instance.isActive,
  'lastRegisteredAtUtc': instance.lastRegisteredAtUtc,
  'lastSeenAtUtc': instance.lastSeenAtUtc,
};
