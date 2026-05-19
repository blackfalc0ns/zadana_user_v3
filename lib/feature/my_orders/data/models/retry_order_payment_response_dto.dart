import 'package:zadana_user_v3/feature/my_orders/domain/entities/retry_order_payment_response_entity.dart';
import 'package:zadana_user_v3/feature/payment/data/models/place_order_response_dto.dart'
    show MoyasarProviderConfigDto, BankTransferConfigDto;

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
    this.paymentFlow,
    this.isPaid,
    this.requiresCustomerAction,
    this.customerAction,
    this.confirmationMode,
    this.bankTransferConfig,
  });

  factory RetryOrderPaymentDto.fromJson(Map<String, dynamic> json) {
    final provider = json['provider']?.toString() ?? '';
    final paymentFlow = json['payment_flow']?.toString();
    final isBankTransfer = paymentFlow == 'manual_bank_transfer' ||
        provider == 'banktransfer';

    return RetryOrderPaymentDto(
      id: json['id']?.toString() ?? '',
      provider: provider,
      status: json['status']?.toString() ?? '',
      iframeUrl: json['iframe_url']?.toString() ?? '',
      providerReference: json['provider_reference']?.toString() ?? '',
      providerConfig: (!isBankTransfer && _nullableMap(json['provider_config']) != null)
          ? MoyasarProviderConfigDto.fromJson(_asMap(json['provider_config']))
          : null,
      paymentFlow: paymentFlow,
      isPaid: json['is_paid'] as bool?,
      requiresCustomerAction: json['requires_customer_action'] as bool?,
      customerAction: json['customer_action']?.toString(),
      confirmationMode: json['confirmation_mode']?.toString(),
      bankTransferConfig: (isBankTransfer && _nullableMap(json['provider_config']) != null)
          ? BankTransferConfigDto.fromJson(_asMap(json['provider_config']))
          : null,
    );
  }

  final String id;
  final String provider;
  final String status;
  final String iframeUrl;
  final String providerReference;
  final MoyasarProviderConfigDto? providerConfig;
  final String? paymentFlow;
  final bool? isPaid;
  final bool? requiresCustomerAction;
  final String? customerAction;
  final String? confirmationMode;
  final BankTransferConfigDto? bankTransferConfig;

  RetryOrderPaymentEntity toEntity() {
    return RetryOrderPaymentEntity(
      id: id,
      provider: provider,
      status: status,
      iframeUrl: iframeUrl,
      providerReference: providerReference,
      providerConfig: providerConfig?.toEntity(),
      paymentFlow: paymentFlow,
      isPaid: isPaid,
      requiresCustomerAction: requiresCustomerAction,
      customerAction: customerAction,
      confirmationMode: confirmationMode,
      bankTransferConfig: bankTransferConfig?.toEntity(),
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  return value is Map<String, dynamic> ? value : <String, dynamic>{};
}

Map<String, dynamic>? _nullableMap(dynamic value) {
  return value is Map<String, dynamic> ? value : null;
}
