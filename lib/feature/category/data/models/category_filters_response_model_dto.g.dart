// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_filters_response_model_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryFiltersResponseModelDto _$CategoryFiltersResponseModelDtoFromJson(
  Map<String, dynamic> json,
) => CategoryFiltersResponseModelDto(
  category: json['category'] == null
      ? null
      : CategoryFilterOptionDto.fromJson(
          json['category'] as Map<String, dynamic>,
        ),
  subcategories: (json['subcategories'] as List<dynamic>?)
      ?.map(
        (e) => CategorySubcategoryItemDto.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  productTypes: (json['product_types'] as List<dynamic>?)
      ?.map((e) => CategoryFilterOptionDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  parts: (json['parts'] as List<dynamic>?)
      ?.map(
        (e) => CategoryFilterPartItemDto.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  quantities: (json['quantities'] as List<dynamic>?)
      ?.map((e) => CategoryFilterOptionDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  brands: (json['brands'] as List<dynamic>?)
      ?.map(
        (e) => CategoryFilterBrandItemDto.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  priceRange: json['price_range'] == null
      ? null
      : CategoryFilterPriceRangeDto.fromJson(
          json['price_range'] as Map<String, dynamic>,
        ),
  sortOptions: (json['sort_options'] as List<dynamic>?)
      ?.map(
        (e) => CategoryFilterSortOptionDto.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$CategoryFiltersResponseModelDtoToJson(
  CategoryFiltersResponseModelDto instance,
) => <String, dynamic>{
  'category': instance.category?.toJson(),
  'subcategories': instance.subcategories?.map((e) => e.toJson()).toList(),
  'product_types': instance.productTypes?.map((e) => e.toJson()).toList(),
  'parts': instance.parts?.map((e) => e.toJson()).toList(),
  'quantities': instance.quantities?.map((e) => e.toJson()).toList(),
  'brands': instance.brands?.map((e) => e.toJson()).toList(),
  'price_range': instance.priceRange?.toJson(),
  'sort_options': instance.sortOptions?.map((e) => e.toJson()).toList(),
};
