class ProductSearchParams {
  const ProductSearchParams({
    required this.title,
    required this.hintText,
    this.categoryId,
    this.brandId,
    this.minPrice,
    this.maxPrice,
    this.sort,
    this.initialQuery = '',
    this.autofocus = false,
  });

  final String title;
  final String hintText;
  final String? categoryId;
  final String? brandId;
  final double? minPrice;
  final double? maxPrice;
  final String? sort;
  final String initialQuery;
  final bool autofocus;

  ProductSearchParams copyWith({
    String? title,
    String? hintText,
    Object? categoryId = const Object(),
    Object? brandId = const Object(),
    Object? minPrice = const Object(),
    Object? maxPrice = const Object(),
    Object? sort = const Object(),
    String? initialQuery,
    bool? autofocus,
  }) {
    return ProductSearchParams(
      title: title ?? this.title,
      hintText: hintText ?? this.hintText,
      categoryId: identical(categoryId, const Object())
          ? this.categoryId
          : categoryId as String?,
      brandId: identical(brandId, const Object())
          ? this.brandId
          : brandId as String?,
      minPrice: identical(minPrice, const Object())
          ? this.minPrice
          : minPrice as double?,
      maxPrice: identical(maxPrice, const Object())
          ? this.maxPrice
          : maxPrice as double?,
      sort: identical(sort, const Object()) ? this.sort : sort as String?,
      initialQuery: initialQuery ?? this.initialQuery,
      autofocus: autofocus ?? this.autofocus,
    );
  }
}
