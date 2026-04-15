class ProductVendorPriceEntity {
  const ProductVendorPriceEntity({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.price,
    this.oldPrice,
    required this.isDiscounted,
  });
  final String id;
  final String name;
  final String? logoUrl;
  final double price;
  final double? oldPrice;
  final bool isDiscounted;
}
