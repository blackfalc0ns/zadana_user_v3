class AddCartItemRequestEntity {
  const AddCartItemRequestEntity({
    required this.productId,
    required this.quantity,
  });

  final String productId;
  final int quantity;
}
