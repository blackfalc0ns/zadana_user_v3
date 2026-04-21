// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_products_response_model_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandProductsResponseModelDto _$BrandProductsResponseModelDtoFromJson(
  Map<String, dynamic> json,
) => BrandProductsResponseModelDto(
  appliedFilters: json['applied_filters'] == null
      ? null
      : BrandProductsAppliedFiltersDto.fromJson(
          json['applied_filters'] as Map<String, dynamic>,
        ),
  total: (json['total'] as num?)?.toInt(),
  page: (json['page'] as num?)?.toInt(),
  perPage: (json['per_page'] as num?)?.toInt(),
  items: (json['items'] as List<dynamic>?)
      ?.map(
        (e) => BrandProductsItemModelDto.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$BrandProductsResponseModelDtoToJson(
  BrandProductsResponseModelDto instance,
) => <String, dynamic>{
  'applied_filters': instance.appliedFilters?.toJson(),
  'total': instance.total,
  'page': instance.page,
  'per_page': instance.perPage,
  'items': instance.items?.map((e) => e.toJson()).toList(),
};
