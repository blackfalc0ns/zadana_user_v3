// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unregister_notification_device_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnregisterNotificationDeviceRequestDto
_$UnregisterNotificationDeviceRequestDtoFromJson(Map<String, dynamic> json) =>
    UnregisterNotificationDeviceRequestDto(
      deviceId: json['deviceId'] as String?,
      deviceToken: json['deviceToken'] as String?,
    );

Map<String, dynamic> _$UnregisterNotificationDeviceRequestDtoToJson(
  UnregisterNotificationDeviceRequestDto instance,
) => <String, dynamic>{
  'deviceId': ?instance.deviceId,
  'deviceToken': ?instance.deviceToken,
};
