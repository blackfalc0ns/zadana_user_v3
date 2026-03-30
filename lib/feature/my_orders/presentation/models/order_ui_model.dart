enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  returning,
  cancelled;

  bool get isActive =>
      this == OrderStatus.pending ||
      this == OrderStatus.processing ||
      this == OrderStatus.shipped;

  bool get isCompleted =>
      this == OrderStatus.delivered;

  bool get isReturning =>
      this == OrderStatus.returning;

  bool get isCancelled =>
      this == OrderStatus.cancelled;

  bool get canCancel =>
      this == OrderStatus.pending || this == OrderStatus.processing;
}

class OrderItemUiModel {
  final String id;
  final String name;
  final int quantity;
  final double price;

  const OrderItemUiModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });
}

class OrderUiModel {
  final String id;
  final DateTime createdAt;
  final double totalPrice;
  final OrderStatus status;
  final List<OrderItemUiModel> items;

  const OrderUiModel({
    required this.id,
    required this.createdAt,
    required this.totalPrice,
    required this.status,
    required this.items,
  });

  int get itemsCount => items.fold(0, (sum, item) => sum + item.quantity);
}
