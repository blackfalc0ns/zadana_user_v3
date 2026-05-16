import 'package:json_annotation/json_annotation.dart';

part 'category_products_applied_filters_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CategoryProductsAppliedFiltersDto {
  const CategoryProductsAppliedFiltersDto({
    this.categoryId,
    this.subcategoryId,
    this.quantityId,
    this.brandId,
    this.packageTypeId,
    this.measurementUnitId,
    this.measurementValue,
    this.minPrice,
    this.maxPrice,
    this.sort,
  });

  factory CategoryProductsAppliedFiltersDto.fromJson(
    Map<String, dynamic> json,
  ) => _$CategoryProductsAppliedFiltersDtoFromJson(json);

  final String? categoryId;
  final String? subcategoryId;
  final String? quantityId;
  final String? brandId;
  final String? packageTypeId;
  final String? measurementUnitId;
  final double? measurementValue;
  final double? minPrice;
  final double? maxPrice;
  final String? sort;

  Map<String, dynamic> toJson() =>
      _$CategoryProductsAppliedFiltersDtoToJson(this);
}
