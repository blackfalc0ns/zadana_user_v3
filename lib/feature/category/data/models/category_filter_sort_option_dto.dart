import 'package:json_annotation/json_annotation.dart';

part 'category_filter_sort_option_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CategoryFilterSortOptionDto {
  const CategoryFilterSortOptionDto({this.label, this.value});

  factory CategoryFilterSortOptionDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryFilterSortOptionDtoFromJson(json);

  final String? label;
  final String? value;

  Map<String, dynamic> toJson() => _$CategoryFilterSortOptionDtoToJson(this);
}
