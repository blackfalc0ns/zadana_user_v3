class ConfirmPaymentResponseEntity {
  const ConfirmPaymentResponseEntity({
    required this.message,
    required this.paymentId,
    required this.paymentStatus,
    required this.userId,
    required this.orderId,
    required this.orderStatus,
    required this.alreadyConfirmed,
  });

  final String message;
  final String paymentId;
  final String paymentStatus;
  final String userId;
  final String orderId;
  final String orderStatus;
  final bool alreadyConfirmed;

  /// Returns true when the backend has confirmed the payment as paid.
  bool get isPaid => paymentStatus.toLowerCase() == 'paid';
}
