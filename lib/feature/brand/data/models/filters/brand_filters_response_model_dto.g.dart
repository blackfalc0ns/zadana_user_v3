// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_filters_response_model_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandFiltersResponseModelDto _$BrandFiltersResponseModelDtoFromJson(
  Map<String, dynamic> json,
) => BrandFiltersResponseModelDto(
  brand: json['brand'] == null
      ? null
      : BrandFilterOptionDto.fromJson(json['brand'] as Map<String, dynamic>),
  categories: (json['categories'] as List<dynamic>?)
      ?.map((e) => BrandFilterOptionDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  subcategories: (json['subcategories'] as List<dynamic>?)
      ?.map(
        (e) =>
            BrandFilterSubcategoryItemDto.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  units: (json['units'] as List<dynamic>?)
      ?.map((e) => BrandFilterOptionDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  packageTypes: (json['package_types'] as List<dynamic>?)
      ?.map((e) => BrandFilterOptionDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  measurementUnits: (json['measurement_units'] as List<dynamic>?)
      ?.map((e) => BrandFilterOptionDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  measurementValues: (json['measurement_values'] as List<dynamic>?)
      ?.map((e) => (e as num).toDouble())
      .toList(),
  priceRange: json['price_range'] == null
      ? null
      : BrandFilterPriceRangeDto.fromJson(
          json['price_range'] as Map<String, dynamic>,
        ),
  sortOptions: (json['sort_options'] as List<dynamic>?)
      ?.map((e) => BrandFilterSortOptionDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BrandFiltersResponseModelDtoToJson(
  BrandFiltersResponseModelDto instance,
) => <String, dynamic>{
  'brand': instance.brand?.toJson(),
  'categories': instance.categories?.map((e) => e.toJson()).toList(),
  'subcategories': instance.subcategories?.map((e) => e.toJson()).toList(),
  'units': instance.units?.map((e) => e.toJson()).toList(),
  'package_types': instance.packageTypes?.map((e) => e.toJson()).toList(),
  'measurement_units': instance.measurementUnits
      ?.map((e) => e.toJson())
      .toList(),
  'measurement_values': instance.measurementValues,
  'price_range': instance.priceRange?.toJson(),
  'sort_options': instance.sortOptions?.map((e) => e.toJson()).toList(),
};
