import 'package:json_annotation/json_annotation.dart';

part 'category_breadcrumb_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CategoryBreadcrumbDto {
  const CategoryBreadcrumbDto({this.category, this.subcategory});

  factory CategoryBreadcrumbDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryBreadcrumbDtoFromJson(json);

  final CategoryBreadcrumbItemDto? category;
  final CategoryBreadcrumbItemDto? subcategory;

  Map<String, dynamic> toJson() => _$CategoryBreadcrumbDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CategoryBreadcrumbItemDto {
  const CategoryBreadcrumbItemDto({this.id, this.name});

  factory CategoryBreadcrumbItemDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryBreadcrumbItemDtoFromJson(json);

  final String? id;
  final String? name;

  Map<String, dynamic> toJson() => _$CategoryBreadcrumbItemDtoToJson(this);
}
