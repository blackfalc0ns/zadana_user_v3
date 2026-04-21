import 'package:json_annotation/json_annotation.dart';

part 'brand_filter_sort_option_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BrandFilterSortOptionDto {
  const BrandFilterSortOptionDto({this.label, this.value});

  factory BrandFilterSortOptionDto.fromJson(Map<String, dynamic> json) =>
      _$BrandFilterSortOptionDtoFromJson(json);

  final String? label;
  final String? value;

  Map<String, dynamic> toJson() => _$BrandFilterSortOptionDtoToJson(this);
}
