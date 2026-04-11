class CartVendorEntity {
  const CartVendorEntity({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.productsCount,
  });

  final String id;
  final String name;
  final String? logoUrl;
  final int productsCount;
}
