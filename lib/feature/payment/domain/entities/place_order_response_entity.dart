class PlaceOrderResponseEntity {
  const PlaceOrderResponseEntity({
    required this.message,
    required this.order,
    this.payment,
  });

  final String message;
  final PlacedOrderEntity order;
  final OrderPaymentEntity? payment;
}

class PlacedOrderEntity {
  const PlacedOrderEntity({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.totalPrice,
  });

  final String id;
  final DateTime createdAt;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final double totalPrice;
}

class OrderPaymentEntity {
  const OrderPaymentEntity({
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
