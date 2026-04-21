import 'package:zadana_user_v3/feature/my_orders/domain/entities/retry_order_payment_response_entity.dart';

class RetryOrderPaymentResponseDto {
  const RetryOrderPaymentResponseDto({
    required this.message,
    required this.payment,
  });

  factory RetryOrderPaymentResponseDto.fromJson(Map<String, dynamic> json) {
    return RetryOrderPaymentResponseDto(
      message: json['message']?.toString() ?? '',
      payment: RetryOrderPaymentDto.fromJson(_asMap(json['payment'])),
    );
  }

  final String message;
  final RetryOrderPaymentDto payment;

  RetryOrderPaymentResponseEntity toEntity() {
    return RetryOrderPaymentResponseEntity(
      message: message,
      payment: payment.toEntity(),
    );
  }
}

class RetryOrderPaymentDto {
  const RetryOrderPaymentDto({
    required this.id,
    required this.provider,
    required this.status,
    required this.iframeUrl,
    required this.providerReference,
  });

  factory RetryOrderPaymentDto.fromJson(Map<String, dynamic> json) {
    return RetryOrderPaymentDto(
      id: json['id']?.toString() ?? '',
      provider: json['provider']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      iframeUrl: json['iframe_url']?.toString() ?? '',
      providerReference: json['provider_reference']?.toString() ?? '',
    );
  }

  final String id;
  final String provider;
  final String status;
  final String iframeUrl;
  final String providerReference;

  RetryOrderPaymentEntity toEntity() {
    return RetryOrderPaymentEntity(
      id: id,
      provider: provider,
      status: status,
      iframeUrl: iframeUrl,
      providerReference: providerReference,
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  return value is Map<String, dynamic> ? value : <String, dynamic>{};
}
