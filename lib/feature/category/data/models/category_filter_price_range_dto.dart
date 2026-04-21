import 'package:json_annotation/json_annotation.dart';

part 'category_filter_price_range_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CategoryFilterPriceRangeDto {
  const CategoryFilterPriceRangeDto({this.min, this.max});

  factory CategoryFilterPriceRangeDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryFilterPriceRangeDtoFromJson(json);

  final double? min;
  final double? max;

  Map<String, dynamic> toJson() => _$CategoryFilterPriceRangeDtoToJson(this);
}
