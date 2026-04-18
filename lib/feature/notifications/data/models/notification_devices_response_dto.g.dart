// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_devices_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationDevicesResponseDto _$NotificationDevicesResponseDtoFromJson(
  Map<String, dynamic> json,
) => NotificationDevicesResponseDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => NotificationDeviceDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$NotificationDevicesResponseDtoToJson(
  NotificationDevicesResponseDto instance,
) => <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
