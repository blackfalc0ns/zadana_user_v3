class CartSummaryEntity {
  const CartSummaryEntity({
    required this.itemsCount,
    required this.totalQuantity,
    this.subtotal,
    this.discountAmount,
    this.totalAmount,
    this.hasUnavailableItems,
    this.unavailableItemsCount,
    this.canCheckout,
    this.checkoutBlockReason,
  });

  final int itemsCount;
  final int totalQuantity;
  final double? subtotal;
  final double? discountAmount;
  final double? totalAmount;
  final bool? hasUnavailableItems;
  final int? unavailableItemsCount;
  final bool? canCheckout;
  final String? checkoutBlockReason;
}
