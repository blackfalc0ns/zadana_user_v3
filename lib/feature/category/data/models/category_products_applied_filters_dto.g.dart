// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_products_applied_filters_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryProductsAppliedFiltersDto _$CategoryProductsAppliedFiltersDtoFromJson(
  Map<String, dynamic> json,
) => CategoryProductsAppliedFiltersDto(
  categoryId: json['category_id'] as String?,
  subcategoryId: json['subcategory_id'] as String?,
  quantityId: json['quantity_id'] as String?,
  brandId: json['brand_id'] as String?,
  minPrice: (json['min_price'] as num?)?.toDouble(),
  maxPrice: (json['max_price'] as num?)?.toDouble(),
  sort: json['sort'] as String?,
);

Map<String, dynamic> _$CategoryProductsAppliedFiltersDtoToJson(
  CategoryProductsAppliedFiltersDto instance,
) => <String, dynamic>{
  'category_id': instance.categoryId,
  'subcategory_id': instance.subcategoryId,
  'quantity_id': instance.quantityId,
  'brand_id': instance.brandId,
  'min_price': instance.minPrice,
  'max_price': instance.maxPrice,
  'sort': instance.sort,
};
