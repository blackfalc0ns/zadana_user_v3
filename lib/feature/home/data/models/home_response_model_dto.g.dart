// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_response_model_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeAppBarModelDto _$HomeAppBarModelDtoFromJson(Map<String, dynamic> json) =>
    HomeAppBarModelDto(
      deliverToLabel: json['deliver_to_label'] as String?,
      location: json['location'] as String?,
      addressLine: json['address_line'] as String?,
      notificationsCount: (json['notifications_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HomeAppBarModelDtoToJson(HomeAppBarModelDto instance) =>
    <String, dynamic>{
      'deliver_to_label': instance.deliverToLabel,
      'location': instance.location,
      'address_line': instance.addressLine,
      'notifications_count': instance.notificationsCount,
    };
