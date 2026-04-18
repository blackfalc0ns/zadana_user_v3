import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/notifications/data/models/notification_device_dto.dart';

part 'notification_devices_response_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class NotificationDevicesResponseDto {
  const NotificationDevicesResponseDto({required this.items});

  factory NotificationDevicesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDevicesResponseDtoFromJson(json);

  final List<NotificationDeviceDto> items;

  Map<String, dynamic> toJson() => _$NotificationDevicesResponseDtoToJson(this);
}
