class VendorPrice {
  final String id;
  final String name;
  final double price;
  final double? oldPrice;
  final bool isDiscounted;

  const VendorPrice({
    required this.id,
    required this.name,
    required this.price,
    this.oldPrice,
    this.isDiscounted = false,
  });
}

class CartItemModel {
  final String id;
  final String name;
  final String imageUrl;
  final String unit;
  final List<VendorPrice> vendorPrices;
  int quantity;

  CartItemModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.unit,
    required this.vendorPrices,
    this.quantity = 1,
  });

  VendorPrice get cheapest =>
      vendorPrices.reduce((a, b) => a.price < b.price ? a : b);
}