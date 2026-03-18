enum ProductSortOption {
  bestSellers,
  priceLowToHigh,
  priceHighToLow,
  newest;

  String get displayName {
    switch (this) {
      case ProductSortOption.bestSellers:
        return 'Best Sellers';
      case ProductSortOption.priceLowToHigh:
        return 'Price: Low to High';
      case ProductSortOption.priceHighToLow:
        return 'Price: High to Low';
      case ProductSortOption.newest:
        return 'Newest';
    }
  }
}
