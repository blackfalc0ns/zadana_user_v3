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
  final String productId;
  final String name;
  final String? imageUrl;
  final String unit;
  final List<VendorPrice> vendorPrices;
  int quantity;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    this.imageUrl,
    required this.unit,
    required this.vendorPrices,
    this.quantity = 1,
  });

  CartItemModel copyWith({
    String? id,
    String? productId,
    String? name,
    String? imageUrl,
    String? unit,
    List<VendorPrice>? vendorPrices,
    int? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      unit: unit ?? this.unit,
      vendorPrices: vendorPrices ?? this.vendorPrices,
      quantity: quantity ?? this.quantity,
    );
  }

  VendorPrice get cheapest =>
      vendorPrices.reduce((a, b) => a.price < b.price ? a : b);

  /// Check if this item is available at a specific vendor
  bool isAvailableAt(String vendorId, {String? loadedVendorId}) {
    return getPriceForVendor(vendorId, loadedVendorId: loadedVendorId) != null;
  }

  /// Get vendor price for a specific vendor, returns null if not available
  VendorPrice? getPriceForVendor(String vendorId, {String? loadedVendorId}) {
    try {
      final vp = vendorPrices.firstWhere((v) => v.id == vendorId);
      return vp.price > 0 ? vp : null;
    } catch (_) {
      final canUseFilteredVendorFallback =
          loadedVendorId == vendorId &&
          vendorPrices.length == 1 &&
          vendorPrices.first.price > 0;

      if (canUseFilteredVendorFallback) {
        return vendorPrices.first;
      }

      return null;
    }
  }
}
