// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_filter_price_range_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryFilterPriceRangeDto _$CategoryFilterPriceRangeDtoFromJson(
  Map<String, dynamic> json,
) => CategoryFilterPriceRangeDto(
  min: (json['min'] as num?)?.toDouble(),
  max: (json['max'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CategoryFilterPriceRangeDtoToJson(
  CategoryFilterPriceRangeDto instance,
) => <String, dynamic>{'min': instance.min, 'max': instance.max};
