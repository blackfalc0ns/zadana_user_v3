import 'package:zadana_user_v3/feature/category/data/models/category_filter_brand_item_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_option_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_part_item_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_price_range_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_sort_option_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';

class CategoryFiltersResponseModelDto {
  final CategoryFilterOptionDto? category;
  final List<CategorySubcategoryItemDto>? subcategories;
  final List<CategoryFilterOptionDto>? productTypes;
  final List<CategoryFilterPartItemDto>? parts;
  final List<CategoryFilterOptionDto>? quantities;
  final List<CategoryFilterBrandItemDto>? brands;
  final CategoryFilterPriceRangeDto? priceRange;
  final List<CategoryFilterSortOptionDto>? sortOptions;

  const CategoryFiltersResponseModelDto({
    this.category,
    this.subcategories,
    this.productTypes,
    this.parts,
    this.quantities,
    this.brands,
    this.priceRange,
    this.sortOptions,
  });

  factory CategoryFiltersResponseModelDto.fromJson(Map<String, dynamic> json) {
    return CategoryFiltersResponseModelDto(
      category: json['category'] == null
          ? null
          : CategoryFilterOptionDto.fromJson(
              json['category'] as Map<String, dynamic>,
            ),
      subcategories: (json['subcategories'] as List<dynamic>?)
          ?.map(
            (item) => CategorySubcategoryItemDto.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      productTypes: (json['product_types'] as List<dynamic>?)
          ?.map(
            (item) => CategoryFilterOptionDto.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      parts: (json['parts'] as List<dynamic>?)
          ?.map(
            (item) => CategoryFilterPartItemDto.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      quantities: (json['quantities'] as List<dynamic>?)
          ?.map(
            (item) => CategoryFilterOptionDto.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      brands: (json['brands'] as List<dynamic>?)
          ?.map(
            (item) => CategoryFilterBrandItemDto.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      priceRange: json['price_range'] == null
          ? null
          : CategoryFilterPriceRangeDto.fromJson(
              json['price_range'] as Map<String, dynamic>,
            ),
      sortOptions: (json['sort_options'] as List<dynamic>?)
          ?.map(
            (item) => CategoryFilterSortOptionDto.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}
