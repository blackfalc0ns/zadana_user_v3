import 'package:json_annotation/json_annotation.dart';

part 'category_filter_part_item_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CategoryFilterPartItemDto {
  const CategoryFilterPartItemDto({this.id, this.name, this.productTypeId});

  factory CategoryFilterPartItemDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryFilterPartItemDtoFromJson(json);

  final String? id;
  final String? name;
  final String? productTypeId;

  Map<String, dynamic> toJson() => _$CategoryFilterPartItemDtoToJson(this);
}
