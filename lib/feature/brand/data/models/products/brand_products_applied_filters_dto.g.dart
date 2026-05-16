// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_products_applied_filters_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandProductsAppliedFiltersDto _$BrandProductsAppliedFiltersDtoFromJson(
  Map<String, dynamic> json,
) => BrandProductsAppliedFiltersDto(
  categoryId: json['category_id'] as String?,
  subcategoryId: json['subcategory_id'] as String?,
  unitId: json['unit_id'] as String?,
  packageTypeId: json['package_type_id'] as String?,
  measurementUnitId: json['measurement_unit_id'] as String?,
  measurementValue: (json['measurement_value'] as num?)?.toDouble(),
  minPrice: (json['min_price'] as num?)?.toDouble(),
  maxPrice: (json['max_price'] as num?)?.toDouble(),
  sort: json['sort'] as String?,
);

Map<String, dynamic> _$BrandProductsAppliedFiltersDtoToJson(
  BrandProductsAppliedFiltersDto instance,
) => <String, dynamic>{
  'category_id': instance.categoryId,
  'subcategory_id': instance.subcategoryId,
  'unit_id': instance.unitId,
  'package_type_id': instance.packageTypeId,
  'measurement_unit_id': instance.measurementUnitId,
  'measurement_value': instance.measurementValue,
  'min_price': instance.minPrice,
  'max_price': instance.maxPrice,
  'sort': instance.sort,
};
