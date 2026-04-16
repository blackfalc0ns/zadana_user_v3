import 'package:zadana_user_v3/feature/brand/domain/entities/brand_applied_filters_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_product_model.dart';

class BrandProductsEntity {
  const BrandProductsEntity({
    this.appliedFilters,
    this.total = 0,
    this.page = 1,
    this.perPage = 0,
    this.items = const [],
  });

  final BrandAppliedFiltersEntity? appliedFilters;
  final int total;
  final int page;
  final int perPage;
  final List<BrandProductModel> items;
}
