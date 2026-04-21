class RetryOrderPaymentResponseEntity {
  const RetryOrderPaymentResponseEntity({
    required this.message,
    required this.payment,
  });

  final String message;
  final RetryOrderPaymentEntity payment;
}

class RetryOrderPaymentEntity {
  const RetryOrderPaymentEntity({
    required this.id,
    required this.provider,
    required this.status,
    required this.iframeUrl,
    required this.providerReference,
  });

  final String id;
  final String provider;
  final String status;
  final String iframeUrl;
  final String providerReference;
}
