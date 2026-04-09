class CategoryProductsAppliedFiltersDto {
  final String? subcategoryId;
  final String? quantityId;
  final String? brandId;
  final double? minPrice;
  final double? maxPrice;
  final String? sort;

  const CategoryProductsAppliedFiltersDto({
    this.subcategoryId,
    this.quantityId,
    this.brandId,
    this.minPrice,
    this.maxPrice,
    this.sort,
  });

  factory CategoryProductsAppliedFiltersDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return CategoryProductsAppliedFiltersDto(
      subcategoryId: json['subcategory_id'] as String?,
      quantityId: json['quantity_id'] as String?,
      brandId: json['brand_id'] as String?,
      minPrice: (json['min_price'] as num?)?.toDouble(),
      maxPrice: (json['max_price'] as num?)?.toDouble(),
      sort: json['sort'] as String?,
    );
  }
}
