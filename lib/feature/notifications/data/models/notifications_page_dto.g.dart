// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_page_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationsPageDto _$NotificationsPageDtoFromJson(
  Map<String, dynamic> json,
) => NotificationsPageDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => AppNotificationDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  page: (json['page'] as num).toInt(),
  perPage: (json['perPage'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  unreadCount: (json['unreadCount'] as num).toInt(),
  hasMore: json['hasMore'] as bool,
);

Map<String, dynamic> _$NotificationsPageDtoToJson(
  NotificationsPageDto instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'page': instance.page,
  'perPage': instance.perPage,
  'total': instance.total,
  'unreadCount': instance.unreadCount,
  'hasMore': instance.hasMore,
};
