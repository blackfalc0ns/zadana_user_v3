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
    this.providerConfig,
  });

  final String id;
  final String provider;
  final String status;
  final String iframeUrl;
  final String providerReference;
  final MoyasarProviderConfigEntity? providerConfig;

  bool get isMoyasarForm =>
      provider == 'moyasar' &&
      iframeUrl.trim().toLowerCase() == 'rendermoyasarform';
}

class MoyasarProviderConfigEntity {
  const MoyasarProviderConfigEntity({
    required this.publishableKey,
    required this.amount,
    required this.currency,
    required this.description,
    required this.callbackUrl,
    required this.methods,
    required this.supportedNetworks,
    required this.metadata,
  });

  final String publishableKey;
  final int amount;
  final String currency;
  final String description;
  final String callbackUrl;
  final List<String> methods;
  final List<String> supportedNetworks;
  final Map<String, String> metadata;
}
