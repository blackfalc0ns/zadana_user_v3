class BrandProductsRequestEntity {
  const BrandProductsRequestEntity({
    required this.brandId,
    required this.brandName,
    this.brandEmoji,
    this.categoryId,
    this.subcategoryId,
    this.unitId,
    this.packageTypeId,
    this.measurementUnitId,
    this.measurementValue,
    this.minPrice,
    this.maxPrice,
    this.sort,
    this.page,
    this.perPage,
  });

  final String brandId;
  final String brandName;
  final String? brandEmoji;
  final String? categoryId;
  final String? subcategoryId;
  final String? unitId;
  final String? packageTypeId;
  final String? measurementUnitId;
  final double? measurementValue;
  final double? minPrice;
  final double? maxPrice;
  final String? sort;
  final int? page;
  final int? perPage;
}
