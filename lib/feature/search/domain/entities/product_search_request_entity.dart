class ProductSearchRequestEntity {
  const ProductSearchRequestEntity({
    required this.query,
    this.categoryId,
    this.brandId,
    this.minPrice,
    this.maxPrice,
    this.sort,
    this.page = 1,
    this.perPage = 20,
  });

  final String query;
  final String? categoryId;
  final String? brandId;
  final double? minPrice;
  final double? maxPrice;
  final String? sort;
  final int page;
  final int perPage;
}
