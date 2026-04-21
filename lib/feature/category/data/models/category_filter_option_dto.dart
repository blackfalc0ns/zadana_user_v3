import 'package:json_annotation/json_annotation.dart';

part 'category_filter_option_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CategoryFilterOptionDto {
  const CategoryFilterOptionDto({this.id, this.name});

  factory CategoryFilterOptionDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryFilterOptionDtoFromJson(json);

  final String? id;
  final String? name;

  Map<String, dynamic> toJson() => _$CategoryFilterOptionDtoToJson(this);
}
