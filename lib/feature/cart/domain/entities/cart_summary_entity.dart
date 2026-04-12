class CartSummaryEntity {
  const CartSummaryEntity({
    required this.itemsCount,
    required this.totalQuantity,
    this.subtotal,
    this.discountAmount,
    this.totalAmount,
  });

  final int itemsCount;
  final int totalQuantity;
  final double? subtotal;
  final double? discountAmount;
  final double? totalAmount;
}
