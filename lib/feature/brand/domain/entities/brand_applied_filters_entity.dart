class BrandAppliedFiltersEntity {
  const BrandAppliedFiltersEntity({
    this.categoryId,
    this.subcategoryId,
    this.unitId,
    this.packageTypeId,
    this.measurementUnitId,
    this.measurementValue,
    this.minPrice,
    this.maxPrice,
    this.sort,
  });

  final String? categoryId;
  final String? subcategoryId;
  final String? unitId;
  final String? packageTypeId;
  final String? measurementUnitId;
  final double? measurementValue;
  final double? minPrice;
  final double? maxPrice;
  final String? sort;
}
