// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_device_preferences_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationDevicePreferencesRequestDto
_$NotificationDevicePreferencesRequestDtoFromJson(Map<String, dynamic> json) =>
    NotificationDevicePreferencesRequestDto(
      deviceId: json['deviceId'] as String?,
      deviceToken: json['deviceToken'] as String?,
      notificationsEnabled: json['notificationsEnabled'] as bool,
    );

Map<String, dynamic> _$NotificationDevicePreferencesRequestDtoToJson(
  NotificationDevicePreferencesRequestDto instance,
) => <String, dynamic>{
  'deviceId': ?instance.deviceId,
  'deviceToken': ?instance.deviceToken,
  'notificationsEnabled': instance.notificationsEnabled,
};
