// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_notification_device_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterNotificationDeviceRequestDto
_$RegisterNotificationDeviceRequestDtoFromJson(Map<String, dynamic> json) =>
    RegisterNotificationDeviceRequestDto(
      deviceToken: json['deviceToken'] as String,
      platform: json['platform'] as String,
      deviceId: json['deviceId'] as String?,
      deviceName: json['deviceName'] as String?,
      appVersion: json['appVersion'] as String?,
      locale: json['locale'] as String?,
      notificationsEnabled: json['notificationsEnabled'] as bool?,
    );

Map<String, dynamic> _$RegisterNotificationDeviceRequestDtoToJson(
  RegisterNotificationDeviceRequestDto instance,
) => <String, dynamic>{
  'deviceToken': instance.deviceToken,
  'platform': instance.platform,
  'deviceId': ?instance.deviceId,
  'deviceName': ?instance.deviceName,
  'appVersion': ?instance.appVersion,
  'locale': ?instance.locale,
  'notificationsEnabled': ?instance.notificationsEnabled,
};
