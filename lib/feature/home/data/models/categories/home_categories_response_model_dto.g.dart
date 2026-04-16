// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_categories_response_model_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeCategoriesResponseModelDto _$HomeCategoriesResponseModelDtoFromJson(
  Map<String, dynamic> json,
) => HomeCategoriesResponseModelDto(
  key: json['key'] as String?,
  title: json['title'] as String?,
  isActive: json['is_active'] as bool?,
  theme: json['theme'] as String?,
  itemsCount: (json['items_count'] as num?)?.toInt(),
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => HomeCategoryItemModelDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$HomeCategoriesResponseModelDtoToJson(
  HomeCategoriesResponseModelDto instance,
) => <String, dynamic>{
  'key': instance.key,
  'title': instance.title,
  'is_active': instance.isActive,
  'theme': instance.theme,
  'items_count': instance.itemsCount,
  'items': instance.items,
};
