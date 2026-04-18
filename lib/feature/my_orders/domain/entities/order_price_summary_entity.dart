class OrderPriceSummaryEntity {
  const OrderPriceSummaryEntity({
    required this.subtotal,
    required this.shippingCost,
    required this.total,
  });

  final double subtotal;
  final double shippingCost;
  final double total;
}
