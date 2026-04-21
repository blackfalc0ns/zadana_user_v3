import 'package:zadana_user_v3/feature/brand/data/models/filters/brand_filters_response_model_dto.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filter_option_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filter_price_range_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filter_sort_option_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filter_subcategory_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filters_entity.dart';

extension BrandFiltersResponseModelDtoMapper on BrandFiltersResponseModelDto {
  BrandFiltersEntity toEntity() {
    return BrandFiltersEntity(
      categories: (categories ?? const [])
          .where(
            (item) =>
                (item.id ?? '').isNotEmpty &&
                (item.name ?? '').trim().isNotEmpty,
          )
          .map(
            (item) => BrandFilterOptionEntity(
              id: item.id ?? '',
              name: item.name?.trim() ?? '',
            ),
          )
          .toList(growable: false),
      subcategories: (subcategories ?? const [])
          .where(
            (item) =>
                (item.id ?? '').isNotEmpty &&
                (item.name ?? '').trim().isNotEmpty,
          )
          .map(
            (item) => BrandFilterSubcategoryEntity(
              id: item.id ?? '',
              name: item.name?.trim() ?? '',
              categoryId: item.categoryId ?? '',
            ),
          )
          .toList(growable: false),
      units: (units ?? const [])
          .where(
            (item) =>
                (item.id ?? '').isNotEmpty &&
                (item.name ?? '').trim().isNotEmpty,
          )
          .map(
            (item) => BrandFilterOptionEntity(
              id: item.id ?? '',
              name: item.name?.trim() ?? '',
            ),
          )
          .toList(growable: false),
      priceRange: BrandFilterPriceRangeEntity(
        min: priceRange?.min ?? 0,
        max: priceRange?.max ?? priceRange?.min ?? 0,
      ),
      sortOptions: (sortOptions ?? const [])
          .where((item) => (item.value ?? '').isNotEmpty)
          .map(
            (item) => BrandFilterSortOptionEntity(
              label: item.label?.trim() ?? item.value ?? '',
              value: item.value ?? '',
            ),
          )
          .toList(growable: false),
    );
  }
}
