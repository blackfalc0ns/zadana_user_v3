import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/brand/data/models/filters/brand_filter_option_dto.dart';
import 'package:zadana_user_v3/feature/brand/data/models/filters/brand_filter_price_range_dto.dart';
import 'package:zadana_user_v3/feature/brand/data/models/filters/brand_filter_sort_option_dto.dart';
import 'package:zadana_user_v3/feature/brand/data/models/filters/brand_filter_subcategory_item_dto.dart';

part 'brand_filters_response_model_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class BrandFiltersResponseModelDto {
  const BrandFiltersResponseModelDto({
    this.brand,
    this.categories,
    this.subcategories,
    this.units,
    this.packageTypes,
    this.measurementUnits,
    this.measurementValues,
    this.priceRange,
    this.sortOptions,
  });

  factory BrandFiltersResponseModelDto.fromJson(Map<String, dynamic> json) =>
      _$BrandFiltersResponseModelDtoFromJson(json);

  final BrandFilterOptionDto? brand;
  final List<BrandFilterOptionDto>? categories;
  final List<BrandFilterSubcategoryItemDto>? subcategories;
  final List<BrandFilterOptionDto>? units;
  final List<BrandFilterOptionDto>? packageTypes;
  final List<BrandFilterOptionDto>? measurementUnits;
  final List<double>? measurementValues;
  final BrandFilterPriceRangeDto? priceRange;
  final List<BrandFilterSortOptionDto>? sortOptions;

  Map<String, dynamic> toJson() => _$BrandFiltersResponseModelDtoToJson(this);
}
