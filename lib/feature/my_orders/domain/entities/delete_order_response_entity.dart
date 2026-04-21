class DeleteOrderResponseEntity {
  const DeleteOrderResponseEntity({
    required this.message,
    required this.orderId,
    required this.deleted,
  });

  final String message;
  final String orderId;
  final bool deleted;
}
