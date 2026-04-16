class BrandProductsRequestEntity {
  const BrandProductsRequestEntity({
    required this.brandId,
    required this.brandName,
    this.brandEmoji,
    this.categoryId,
    this.subcategoryId,
    this.unitId,
    this.minPrice,
    this.maxPrice,
    this.sort,
  });

  final String brandId;
  final String brandName;
  final String? brandEmoji;
  final String? categoryId;
  final String? subcategoryId;
  final String? unitId;
  final double? minPrice;
  final double? maxPrice;
  final String? sort;
}
