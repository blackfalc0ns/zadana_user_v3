import 'package:json_annotation/json_annotation.dart';

part 'brand_filter_subcategory_item_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BrandFilterSubcategoryItemDto {
  const BrandFilterSubcategoryItemDto({
    this.id,
    this.name,
    this.categoryId,
    this.imageUrl,
  });

  factory BrandFilterSubcategoryItemDto.fromJson(Map<String, dynamic> json) =>
      _$BrandFilterSubcategoryItemDtoFromJson(json);

  final String? id;
  final String? name;
  final String? categoryId;
  final String? imageUrl;

  Map<String, dynamic> toJson() => _$BrandFilterSubcategoryItemDtoToJson(this);
}
