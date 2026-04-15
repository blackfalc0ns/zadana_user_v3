import 'package:zadana_user_v3/feature/brand/data/models/brand_filter_option_dto.dart';
import 'package:zadana_user_v3/feature/brand/data/models/brand_filter_price_range_dto.dart';
import 'package:zadana_user_v3/feature/brand/data/models/brand_filter_sort_option_dto.dart';
import 'package:zadana_user_v3/feature/brand/data/models/brand_filter_subcategory_item_dto.dart';

class BrandFiltersResponseModelDto {
  const BrandFiltersResponseModelDto({
    this.brand,
    this.categories,
    this.subcategories,
    this.units,
    this.priceRange,
    this.sortOptions,
  });

  factory BrandFiltersResponseModelDto.fromJson(Map<String, dynamic> json) {
    return BrandFiltersResponseModelDto(
      brand: json['brand'] == null
          ? null
          : BrandFilterOptionDto.fromJson(
              json['brand'] as Map<String, dynamic>,
            ),
      categories: (json['categories'] as List<dynamic>?)
          ?.map(
            (item) =>
                BrandFilterOptionDto.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      subcategories: (json['subcategories'] as List<dynamic>?)
          ?.map(
            (item) => BrandFilterSubcategoryItemDto.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      units: (json['units'] as List<dynamic>?)
          ?.map(
            (item) =>
                BrandFilterOptionDto.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      priceRange: json['price_range'] == null
          ? null
          : BrandFilterPriceRangeDto.fromJson(
              json['price_range'] as Map<String, dynamic>,
            ),
      sortOptions: (json['sort_options'] as List<dynamic>?)
          ?.map(
            (item) =>
                BrandFilterSortOptionDto.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
  final BrandFilterOptionDto? brand;
  final List<BrandFilterOptionDto>? categories;
  final List<BrandFilterSubcategoryItemDto>? subcategories;
  final List<BrandFilterOptionDto>? units;
  final BrandFilterPriceRangeDto? priceRange;
  final List<BrandFilterSortOptionDto>? sortOptions;
}
