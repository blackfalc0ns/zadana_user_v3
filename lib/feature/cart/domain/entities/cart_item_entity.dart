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

  /// Check if this item is available at a specific vendor
  bool isAvailableAt(String vendorId) {
    return vendorPrices.any((v) => v.id == vendorId && v.price > 0);
  }

  /// Get vendor price for a specific vendor, returns null if not available
  VendorPrice? getPriceForVendor(String vendorId) {
    try {
      final vp = vendorPrices.firstWhere(
        (v) => v.id == vendorId,
      );
      return vp.price > 0 ? vp : null;
    } catch (_) {
      return null;
    }
  }
}