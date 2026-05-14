import 'package:json_annotation/json_annotation.dart';

part 'category_subcategory_item_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CategorySubcategoryItemDto {
  const CategorySubcategoryItemDto({
    this.id,
    this.name,
    this.imageUrl,
    this.categoryId,
  });

  factory CategorySubcategoryItemDto.fromJson(Map<String, dynamic> json) =>
      _$CategorySubcategoryItemDtoFromJson(json);

  final String? id;
  final String? name;
  final String? imageUrl;
  final String? categoryId;

  Map<String, dynamic> toJson() => _$CategorySubcategoryItemDtoToJson(this);
}
