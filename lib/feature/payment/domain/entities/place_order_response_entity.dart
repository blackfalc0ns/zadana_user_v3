import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';

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
    this.fulfillmentType,
    this.pickupBranch,
  });

  final String id;
  final DateTime createdAt;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final double totalPrice;
  final String? fulfillmentType;
  final CheckoutBranchEntity? pickupBranch;
}

class OrderPaymentEntity {
  const OrderPaymentEntity({
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

  /// New fields from backend payment response.
  final String? paymentFlow;
  final bool? isPaid;
  final bool? requiresCustomerAction;
  final String? customerAction;
  final String? confirmationMode;
  final BankTransferConfigEntity? bankTransferConfig;

  bool get isMoyasarForm =>
      provider == 'moyasar' &&
      iframeUrl.trim().toLowerCase() == 'rendermoyasarform';

  /// Returns true when the payment flow is manual bank transfer.
  bool get isBankTransfer =>
      paymentFlow == 'manual_bank_transfer' ||
      provider == 'banktransfer';

  /// Returns true when the payment flow is online gateway (card/Moyasar).
  bool get isOnlineGateway =>
      paymentFlow == 'online_gateway' ||
      (paymentFlow == null && provider == 'moyasar');
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

/// Bank transfer provider config returned when payment_flow == "manual_bank_transfer".
class BankTransferConfigEntity {
  const BankTransferConfigEntity({
    required this.bankName,
    required this.accountHolderName,
    required this.iban,
    required this.accountNumber,
    required this.countryCode,
    required this.city,
    required this.reference,
    required this.amount,
    required this.currency,
    this.expiresAtUtc,
    this.webhookDriven = true,
  });

  final String bankName;
  final String accountHolderName;
  final String iban;
  final String accountNumber;
  final String countryCode;
  final String city;
  final String reference;
  final double amount;
  final String currency;
  final String? expiresAtUtc;
  final bool webhookDriven;
}
