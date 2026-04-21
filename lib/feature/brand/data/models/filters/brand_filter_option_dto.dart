import 'package:json_annotation/json_annotation.dart';

part 'brand_filter_option_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BrandFilterOptionDto {
  const BrandFilterOptionDto({this.id, this.name});

  factory BrandFilterOptionDto.fromJson(Map<String, dynamic> json) =>
      _$BrandFilterOptionDtoFromJson(json);

  final String? id;
  final String? name;

  Map<String, dynamic> toJson() => _$BrandFilterOptionDtoToJson(this);
}
