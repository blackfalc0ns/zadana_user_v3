import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_brand_item_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_option_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_part_item_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_price_range_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_sort_option_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';

part 'category_filters_response_model_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CategoryFiltersResponseModelDto {
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

  factory CategoryFiltersResponseModelDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryFiltersResponseModelDtoFromJson(json);

  final CategoryFilterOptionDto? category;
  final List<CategorySubcategoryItemDto>? subcategories;
  final List<CategoryFilterOptionDto>? productTypes;
  final List<CategoryFilterPartItemDto>? parts;
  final List<CategoryFilterOptionDto>? quantities;
  final List<CategoryFilterBrandItemDto>? brands;
  final CategoryFilterPriceRangeDto? priceRange;
  final List<CategoryFilterSortOptionDto>? sortOptions;

  Map<String, dynamic> toJson() =>
      _$CategoryFiltersResponseModelDtoToJson(this);
}
