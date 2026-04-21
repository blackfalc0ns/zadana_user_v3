import 'package:json_annotation/json_annotation.dart';

part 'brand_products_applied_filters_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BrandProductsAppliedFiltersDto {
  const BrandProductsAppliedFiltersDto({
    this.categoryId,
    this.subcategoryId,
    this.unitId,
    this.minPrice,
    this.maxPrice,
    this.sort,
  });

  factory BrandProductsAppliedFiltersDto.fromJson(Map<String, dynamic> json) =>
      _$BrandProductsAppliedFiltersDtoFromJson(json);

  final String? categoryId;
  final String? subcategoryId;
  final String? unitId;
  final double? minPrice;
  final double? maxPrice;
  final String? sort;

  Map<String, dynamic> toJson() => _$BrandProductsAppliedFiltersDtoToJson(this);
}
