class BrandProductsAppliedFiltersDto {
  final String? categoryId;
  final String? subcategoryId;
  final String? unitId;
  final double? minPrice;
  final double? maxPrice;
  final String? sort;

  const BrandProductsAppliedFiltersDto({
    this.categoryId,
    this.subcategoryId,
    this.unitId,
    this.minPrice,
    this.maxPrice,
    this.sort,
  });

  factory BrandProductsAppliedFiltersDto.fromJson(Map<String, dynamic> json) {
    return BrandProductsAppliedFiltersDto(
      categoryId: json['category_id'] as String?,
      subcategoryId: json['subcategory_id'] as String?,
      unitId: json['unit_id'] as String?,
      minPrice: (json['min_price'] as num?)?.toDouble(),
      maxPrice: (json['max_price'] as num?)?.toDouble(),
      sort: json['sort'] as String?,
    );
  }
}
