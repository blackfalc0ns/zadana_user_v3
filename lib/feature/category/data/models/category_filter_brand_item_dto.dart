import 'package:json_annotation/json_annotation.dart';

part 'category_filter_brand_item_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CategoryFilterBrandItemDto {
  const CategoryFilterBrandItemDto({this.id, this.name, this.logoUrl});

  factory CategoryFilterBrandItemDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryFilterBrandItemDtoFromJson(json);

  final String? id;
  final String? name;
  final String? logoUrl;

  Map<String, dynamic> toJson() => _$CategoryFilterBrandItemDtoToJson(this);
}
