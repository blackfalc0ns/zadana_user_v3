import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_products_applied_filters_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_products_item_model_dto.dart';

part 'category_products_response_model_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CategoryProductsResponseModelDto {
  const CategoryProductsResponseModelDto({
    this.appliedFilters,
    this.total,
    this.page,
    this.perPage,
    this.items,
  });

  factory CategoryProductsResponseModelDto.fromJson(
    Map<String, dynamic> json,
  ) => _$CategoryProductsResponseModelDtoFromJson(json);

  final CategoryProductsAppliedFiltersDto? appliedFilters;
  final int? total;
  final int? page;
  final int? perPage;
  final List<CategoryProductsItemModelDto>? items;

  Map<String, dynamic> toJson() =>
      _$CategoryProductsResponseModelDtoToJson(this);
}
