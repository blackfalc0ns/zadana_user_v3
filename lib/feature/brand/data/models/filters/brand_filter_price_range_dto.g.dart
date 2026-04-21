// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_filter_price_range_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandFilterPriceRangeDto _$BrandFilterPriceRangeDtoFromJson(
  Map<String, dynamic> json,
) => BrandFilterPriceRangeDto(
  min: (json['min'] as num?)?.toDouble(),
  max: (json['max'] as num?)?.toDouble(),
);

Map<String, dynamic> _$BrandFilterPriceRangeDtoToJson(
  BrandFilterPriceRangeDto instance,
) => <String, dynamic>{'min': instance.min, 'max': instance.max};
