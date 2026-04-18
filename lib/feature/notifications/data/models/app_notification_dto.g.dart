// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppNotificationDto _$AppNotificationDtoFromJson(Map<String, dynamic> json) =>
    AppNotificationDto(
      id: json['id'] as String,
      titleAr: json['titleAr'] as String?,
      titleEn: json['titleEn'] as String?,
      bodyAr: json['bodyAr'] as String?,
      bodyEn: json['bodyEn'] as String?,
      type: json['type'] as String?,
      referenceId: json['referenceId'] as String?,
      data: json['data'] as String?,
      dataObject: json['dataObject'] as Map<String, dynamic>?,
      isRead: json['isRead'] as bool?,
      createdAtUtc: json['createdAtUtc'] as String?,
    );

Map<String, dynamic> _$AppNotificationDtoToJson(AppNotificationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titleAr': instance.titleAr,
      'titleEn': instance.titleEn,
      'bodyAr': instance.bodyAr,
      'bodyEn': instance.bodyEn,
      'type': instance.type,
      'referenceId': instance.referenceId,
      'data': instance.data,
      'dataObject': instance.dataObject,
      'isRead': instance.isRead,
      'createdAtUtc': instance.createdAtUtc,
    };
