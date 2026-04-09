import 'package:zadana_user_v3/feature/category/data/models/category_products_applied_filters_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_products_item_model_dto.dart';

class CategoryProductsResponseModelDto {
  final CategoryProductsAppliedFiltersDto? appliedFilters;
  final int? total;
  final int? page;
  final int? perPage;
  final List<CategoryProductsItemModelDto>? items;

  const CategoryProductsResponseModelDto({
    this.appliedFilters,
    this.total,
    this.page,
    this.perPage,
    this.items,
  });

  factory CategoryProductsResponseModelDto.fromJson(Map<String, dynamic> json) {
    return CategoryProductsResponseModelDto(
      appliedFilters: json['applied_filters'] == null
          ? null
          : CategoryProductsAppliedFiltersDto.fromJson(
              json['applied_filters'] as Map<String, dynamic>,
            ),
      total: json['total'] as int?,
      page: json['page'] as int?,
      perPage: json['per_page'] as int?,
      items: (json['items'] as List<dynamic>?)
          ?.map(
            (item) => CategoryProductsItemModelDto.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}
