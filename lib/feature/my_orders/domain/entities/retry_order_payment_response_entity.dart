import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_response_entity.dart';

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
