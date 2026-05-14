class ShoppingProductsRequestEntity {
  const ShoppingProductsRequestEntity({
    this.categoryId,
    this.subCategoryId,
    this.productTypeId,
    this.partId,
    this.quantityId,
    this.brandId,
    this.minPrice,
    this.maxPrice,
    this.sort,
    this.page = 1,
    this.perPage = 20,
  });

  final String? categoryId;
  final String? subCategoryId;
  final String? productTypeId;
  final String? partId;
  final String? quantityId;
  final String? brandId;
  final double? minPrice;
  final double? maxPrice;
  final String? sort;
  final int page;
  final int perPage;
}
