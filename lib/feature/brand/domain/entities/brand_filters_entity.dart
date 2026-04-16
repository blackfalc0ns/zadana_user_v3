import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filter_option_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filter_price_range_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filter_sort_option_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filter_subcategory_entity.dart';

class BrandFiltersEntity {
  const BrandFiltersEntity({
    this.categories = const [],
    this.subcategories = const [],
    this.units = const [],
    this.priceRange = const BrandFilterPriceRangeEntity(min: 0, max: 0),
    this.sortOptions = const [],
  });

  final List<BrandFilterOptionEntity> categories;
  final List<BrandFilterSubcategoryEntity> subcategories;
  final List<BrandFilterOptionEntity> units;
  final BrandFilterPriceRangeEntity priceRange;
  final List<BrandFilterSortOptionEntity> sortOptions;
}
