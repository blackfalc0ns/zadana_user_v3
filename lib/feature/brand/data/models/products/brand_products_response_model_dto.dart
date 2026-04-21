import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/brand/data/models/products/brand_products_applied_filters_dto.dart';
import 'package:zadana_user_v3/feature/brand/data/models/products/brand_products_item_model_dto.dart';

part 'brand_products_response_model_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class BrandProductsResponseModelDto {
  const BrandProductsResponseModelDto({
    this.appliedFilters,
    this.total,
    this.page,
    this.perPage,
    this.items,
  });

  factory BrandProductsResponseModelDto.fromJson(Map<String, dynamic> json) =>
      _$BrandProductsResponseModelDtoFromJson(json);

  final BrandProductsAppliedFiltersDto? appliedFilters;
  final int? total;
  final int? page;
  final int? perPage;
  final List<BrandProductsItemModelDto>? items;

  Map<String, dynamic> toJson() => _$BrandProductsResponseModelDtoToJson(this);
}
