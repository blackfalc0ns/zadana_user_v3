import 'package:zadana_user_v3/feature/my_orders/domain/entities/retry_order_payment_response_entity.dart';
import 'package:zadana_user_v3/feature/payment/data/models/place_order_response_dto.dart'
    show MoyasarProviderConfigDto;

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
    this.providerConfig,
  });

  factory RetryOrderPaymentDto.fromJson(Map<String, dynamic> json) {
    return RetryOrderPaymentDto(
      id: json['id']?.toString() ?? '',
      provider: json['provider']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      iframeUrl: json['iframe_url']?.toString() ?? '',
      providerReference: json['provider_reference']?.toString() ?? '',
      providerConfig: _nullableMap(json['provider_config']) != null
          ? MoyasarProviderConfigDto.fromJson(_asMap(json['provider_config']))
          : null,
    );
  }

  final String id;
  final String provider;
  final String status;
  final String iframeUrl;
  final String providerReference;
  final MoyasarProviderConfigDto? providerConfig;

  RetryOrderPaymentEntity toEntity() {
    return RetryOrderPaymentEntity(
      id: id,
      provider: provider,
      status: status,
      iframeUrl: iframeUrl,
      providerReference: providerReference,
      providerConfig: providerConfig?.toEntity(),
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  return value is Map<String, dynamic> ? value : <String, dynamic>{};
}

Map<String, dynamic>? _nullableMap(dynamic value) {
  return value is Map<String, dynamic> ? value : null;
}
