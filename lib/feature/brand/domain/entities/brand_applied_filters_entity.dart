class BrandAppliedFiltersEntity {
  const BrandAppliedFiltersEntity({
    this.categoryId,
    this.subcategoryId,
    this.unitId,
    this.minPrice,
    this.maxPrice,
    this.sort,
  });

  final String? categoryId;
  final String? subcategoryId;
  final String? unitId;
  final double? minPrice;
  final double? maxPrice;
  final String? sort;
}
