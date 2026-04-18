// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_action_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationActionResponseDto _$NotificationActionResponseDtoFromJson(
  Map<String, dynamic> json,
) => NotificationActionResponseDto(
  message: json['message'] as String?,
  count: (json['count'] as num?)?.toInt(),
);

Map<String, dynamic> _$NotificationActionResponseDtoToJson(
  NotificationActionResponseDto instance,
) => <String, dynamic>{'message': instance.message, 'count': instance.count};
