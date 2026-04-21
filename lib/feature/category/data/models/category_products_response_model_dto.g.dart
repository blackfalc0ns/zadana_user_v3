// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_products_response_model_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryProductsResponseModelDto _$CategoryProductsResponseModelDtoFromJson(
  Map<String, dynamic> json,
) => CategoryProductsResponseModelDto(
  appliedFilters: json['applied_filters'] == null
      ? null
      : CategoryProductsAppliedFiltersDto.fromJson(
          json['applied_filters'] as Map<String, dynamic>,
        ),
  total: (json['total'] as num?)?.toInt(),
  page: (json['page'] as num?)?.toInt(),
  perPage: (json['per_page'] as num?)?.toInt(),
  items: (json['items'] as List<dynamic>?)
      ?.map(
        (e) => CategoryProductsItemModelDto.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$CategoryProductsResponseModelDtoToJson(
  CategoryProductsResponseModelDto instance,
) => <String, dynamic>{
  'applied_filters': instance.appliedFilters?.toJson(),
  'total': instance.total,
  'page': instance.page,
  'per_page': instance.perPage,
  'items': instance.items?.map((e) => e.toJson()).toList(),
};
