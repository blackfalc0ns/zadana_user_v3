// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_breadcrumb_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryBreadcrumbDto _$CategoryBreadcrumbDtoFromJson(
  Map<String, dynamic> json,
) => CategoryBreadcrumbDto(
  category: json['category'] == null
      ? null
      : CategoryBreadcrumbItemDto.fromJson(
          json['category'] as Map<String, dynamic>,
        ),
  subcategory: json['subcategory'] == null
      ? null
      : CategoryBreadcrumbItemDto.fromJson(
          json['subcategory'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$CategoryBreadcrumbDtoToJson(
  CategoryBreadcrumbDto instance,
) => <String, dynamic>{
  'category': instance.category,
  'subcategory': instance.subcategory,
};

CategoryBreadcrumbItemDto _$CategoryBreadcrumbItemDtoFromJson(
  Map<String, dynamic> json,
) => CategoryBreadcrumbItemDto(
  id: json['id'] as String?,
  name: json['name'] as String?,
);

Map<String, dynamic> _$CategoryBreadcrumbItemDtoToJson(
  CategoryBreadcrumbItemDto instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};
