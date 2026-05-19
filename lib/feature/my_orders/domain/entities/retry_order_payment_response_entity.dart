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
    this.paymentFlow,
    this.isPaid,
    this.requiresCustomerAction,
    this.customerAction,
    this.confirmationMode,
    this.bankTransferConfig,
  });

  final String id;
  final String provider;
  final String status;
  final String iframeUrl;
  final String providerReference;
  final MoyasarProviderConfigEntity? providerConfig;
  final String? paymentFlow;
  final bool? isPaid;
  final bool? requiresCustomerAction;
  final String? customerAction;
  final String? confirmationMode;
  final BankTransferConfigEntity? bankTransferConfig;

  bool get isMoyasarForm =>
      provider == 'moyasar' &&
      iframeUrl.trim().toLowerCase() == 'rendermoyasarform';

  bool get isBankTransfer =>
      paymentFlow == 'manual_bank_transfer' ||
      provider == 'banktransfer';
}
