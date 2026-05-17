class OrderItemEntity {
  const OrderItemEntity({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.imageUrl,
    this.unit,
  });

  final String id;
  final String name;
  final int quantity;
  final double price;
  final String? imageUrl;
  final String? unit;
}
