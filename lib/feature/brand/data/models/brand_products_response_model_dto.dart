import 'package:zadana_user_v3/feature/brand/data/models/brand_products_applied_filters_dto.dart';
import 'package:zadana_user_v3/feature/brand/data/models/brand_products_item_model_dto.dart';

class BrandProductsResponseModelDto {
  final BrandProductsAppliedFiltersDto? appliedFilters;
  final int? total;
  final int? page;
  final int? perPage;
  final List<BrandProductsItemModelDto>? items;

  const BrandProductsResponseModelDto({
    this.appliedFilters,
    this.total,
    this.page,
    this.perPage,
    this.items,
  });

  factory BrandProductsResponseModelDto.fromJson(Map<String, dynamic> json) {
    return BrandProductsResponseModelDto(
      appliedFilters: json['applied_filters'] == null
          ? null
          : BrandProductsAppliedFiltersDto.fromJson(
              json['applied_filters'] as Map<String, dynamic>,
            ),
      total: json['total'] as int?,
      page: json['page'] as int?,
      perPage: json['per_page'] as int?,
      items: (json['items'] as List<dynamic>?)
          ?.map(
            (item) =>
                BrandProductsItemModelDto.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
