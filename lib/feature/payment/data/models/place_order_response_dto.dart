import 'package:zadana_user_v3/core/utils/localized_api_message.dart';
import 'package:zadana_user_v3/feature/payment/data/models/checkout_summary_dto.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_response_entity.dart';

class PlaceOrderResponseDto {
  const PlaceOrderResponseDto({
    required this.message,
    required this.order,
    this.payment,
  });

  factory PlaceOrderResponseDto.fromJson(Map<String, dynamic> json) {
    return PlaceOrderResponseDto(
      message: resolveLocalizedApiMessage(json),
      order: PlacedOrderDto.fromJson(_asMap(json['order'])),
      payment: _nullableMap(json['payment']) == null
          ? null
          : OrderPaymentDto.fromJson(_asMap(json['payment'])),
    );
  }

  final String message;
  final PlacedOrderDto order;
  final OrderPaymentDto? payment;

  PlaceOrderResponseEntity toEntity() {
    return PlaceOrderResponseEntity(
      message: message,
      order: order.toEntity(),
      payment: payment?.toEntity(),
    );
  }
}

class PlacedOrderDto {
  const PlacedOrderDto({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.totalPrice,
    this.fulfillmentType,
    this.pickupBranch,
  });

  factory PlacedOrderDto.fromJson(Map<String, dynamic> json) {
    return PlacedOrderDto(
      id: json['id']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      status: json['status']?.toString() ?? '',
      paymentMethod: json['payment_method']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
      totalPrice: _asDouble(json['total_price']),
      fulfillmentType: json['fulfillment_type']?.toString(),
      pickupBranch: _nullableMap(json['pickup_branch']) == null
          ? null
          : CheckoutBranchDto.fromJson(_asMap(json['pickup_branch'])),
    );
  }

  final String id;
  final DateTime createdAt;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final double totalPrice;
  final String? fulfillmentType;
  final CheckoutBranchDto? pickupBranch;

  PlacedOrderEntity toEntity() {
    return PlacedOrderEntity(
      id: id,
      createdAt: createdAt,
      status: status,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      totalPrice: totalPrice,
      fulfillmentType: fulfillmentType,
      pickupBranch: pickupBranch?.toEntity(),
    );
  }
}

class OrderPaymentDto {
  const OrderPaymentDto({
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

  factory OrderPaymentDto.fromJson(Map<String, dynamic> json) {
    final provider = json['provider']?.toString() ?? '';
    final paymentFlow = json['payment_flow']?.toString();

    // Determine if this is a bank transfer to parse provider_config correctly.
    final isBankTransfer = paymentFlow == 'manual_bank_transfer' ||
        provider == 'banktransfer';

    return OrderPaymentDto(
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

  OrderPaymentEntity toEntity() {
    return OrderPaymentEntity(
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

class BankTransferConfigDto {
  const BankTransferConfigDto({
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

  factory BankTransferConfigDto.fromJson(Map<String, dynamic> json) {
    return BankTransferConfigDto(
      bankName: json['bankName']?.toString() ?? '',
      accountHolderName: json['accountHolderName']?.toString() ?? '',
      iban: json['iban']?.toString() ?? '',
      accountNumber: json['accountNumber']?.toString() ?? '',
      countryCode: json['countryCode']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      reference: json['reference']?.toString() ?? '',
      amount: _asDouble(json['amount']),
      currency: json['currency']?.toString() ?? 'SAR',
      expiresAtUtc: json['expiresAtUtc']?.toString(),
      webhookDriven: json['webhookDriven'] as bool? ?? true,
    );
  }

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

  BankTransferConfigEntity toEntity() {
    return BankTransferConfigEntity(
      bankName: bankName,
      accountHolderName: accountHolderName,
      iban: iban,
      accountNumber: accountNumber,
      countryCode: countryCode,
      city: city,
      reference: reference,
      amount: amount,
      currency: currency,
      expiresAtUtc: expiresAtUtc,
      webhookDriven: webhookDriven,
    );
  }
}

class MoyasarProviderConfigDto {
  const MoyasarProviderConfigDto({
    required this.publishableKey,
    required this.amount,
    required this.currency,
    required this.description,
    required this.callbackUrl,
    required this.methods,
    required this.supportedNetworks,
    required this.metadata,
  });

  factory MoyasarProviderConfigDto.fromJson(Map<String, dynamic> json) {
    return MoyasarProviderConfigDto(
      publishableKey: json['publishableKey']?.toString() ?? '',
      amount: _asInt(json['amount']),
      currency: json['currency']?.toString() ?? 'SAR',
      description: json['description']?.toString() ?? '',
      callbackUrl: json['callbackUrl']?.toString() ?? '',
      methods: _asStringList(json['methods']),
      supportedNetworks: _asStringList(json['supportedNetworks']),
      metadata: _asStringMap(json['metadata']),
    );
  }

  final String publishableKey;
  final int amount;
  final String currency;
  final String description;
  final String callbackUrl;
  final List<String> methods;
  final List<String> supportedNetworks;
  final Map<String, String> metadata;

  MoyasarProviderConfigEntity toEntity() {
    return MoyasarProviderConfigEntity(
      publishableKey: publishableKey,
      amount: amount,
      currency: currency,
      description: description,
      callbackUrl: callbackUrl,
      methods: methods,
      supportedNetworks: supportedNetworks,
      metadata: metadata,
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  return value is Map<String, dynamic> ? value : <String, dynamic>{};
}

Map<String, dynamic>? _nullableMap(dynamic value) {
  return value is Map<String, dynamic> ? value : null;
}

double _asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

List<String> _asStringList(dynamic value) {
  if (value is List) {
    return value.map((e) => e?.toString() ?? '').where((e) => e.isNotEmpty).toList();
  }
  return const [];
}

Map<String, String> _asStringMap(dynamic value) {
  if (value is Map) {
    return value.map((key, val) => MapEntry(key.toString(), val?.toString() ?? ''));
  }
  return const {};
}
