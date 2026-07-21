class VendorPrice {
  const VendorPrice({
    required this.id,
    required this.name,
    required this.price,
    this.oldPrice,
    this.isDiscounted = false,
  });
  final String id;
  final String name;
  final double price;
  final double? oldPrice;
  final bool isDiscounted;
}

class CartItemModel {
  CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    this.imageUrl,
    required this.unit,
    required this.vendorPrices,
    this.quantity = 1,
    this.isAvailableAtBranch,
  });
  final String id;
  final String productId;
  final String name;
  final String? imageUrl;
  final String unit;
  final List<VendorPrice> vendorPrices;
  int quantity;

  /// Explicit availability flag from the server based on the customer's
  /// default address branch. When non-null, takes priority over
  /// vendor-price-based availability inference.
  final bool? isAvailableAtBranch;

  CartItemModel copyWith({
    String? id,
    String? productId,
    String? name,
    String? imageUrl,
    String? unit,
    List<VendorPrice>? vendorPrices,
    int? quantity,
    bool? isAvailableAtBranch,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      unit: unit ?? this.unit,
      vendorPrices: vendorPrices ?? this.vendorPrices,
      quantity: quantity ?? this.quantity,
      isAvailableAtBranch: isAvailableAtBranch ?? this.isAvailableAtBranch,
    );
  }

  /// The lowest vendor price, or null when the item has no price data.
  ///
  /// Price data can temporarily be absent while the cart is refreshed or
  /// when an item is unavailable at every vendor.
  VendorPrice? get cheapestOrNull {
    if (vendorPrices.isEmpty) return null;
    return vendorPrices.reduce((a, b) => a.price < b.price ? a : b);
  }

  /// Check if this item is available at a specific vendor.
  /// Uses the server-provided [isAvailableAtBranch] flag when available,
  /// otherwise falls back to vendor-price-based inference.
  bool isAvailableAt(String vendorId, {String? loadedVendorId}) {
    // When the server explicitly returns availability for the customer's
    // address branch, honour it directly.
    if (isAvailableAtBranch != null) {
      return isAvailableAtBranch!;
    }
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
