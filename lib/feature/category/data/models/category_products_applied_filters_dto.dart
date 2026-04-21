import 'package:json_annotation/json_annotation.dart';

part 'category_products_applied_filters_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CategoryProductsAppliedFiltersDto {
  const CategoryProductsAppliedFiltersDto({
    this.subcategoryId,
    this.quantityId,
    this.brandId,
    this.minPrice,
    this.maxPrice,
    this.sort,
  });

  factory CategoryProductsAppliedFiltersDto.fromJson(
    Map<String, dynamic> json,
  ) => _$CategoryProductsAppliedFiltersDtoFromJson(json);

  final String? subcategoryId;
  final String? quantityId;
  final String? brandId;
  final double? minPrice;
  final double? maxPrice;
  final String? sort;

  Map<String, dynamic> toJson() =>
      _$CategoryProductsAppliedFiltersDtoToJson(this);
}
