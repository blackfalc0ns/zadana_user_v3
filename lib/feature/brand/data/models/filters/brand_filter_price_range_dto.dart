import 'package:json_annotation/json_annotation.dart';

part 'brand_filter_price_range_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BrandFilterPriceRangeDto {
  const BrandFilterPriceRangeDto({this.min, this.max});

  factory BrandFilterPriceRangeDto.fromJson(Map<String, dynamic> json) =>
      _$BrandFilterPriceRangeDtoFromJson(json);

  final double? min;
  final double? max;

  Map<String, dynamic> toJson() => _$BrandFilterPriceRangeDtoToJson(this);
}
