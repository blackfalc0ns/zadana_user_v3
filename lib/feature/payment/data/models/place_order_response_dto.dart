import 'package:zadana_user_v3/core/utils/localized_api_message.dart';
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
    );
  }

  final String id;
  final DateTime createdAt;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final double totalPrice;

  PlacedOrderEntity toEntity() {
    return PlacedOrderEntity(
      id: id,
      createdAt: createdAt,
      status: status,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      totalPrice: totalPrice,
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
  });

  factory OrderPaymentDto.fromJson(Map<String, dynamic> json) {
    return OrderPaymentDto(
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

  OrderPaymentEntity toEntity() {
    return OrderPaymentEntity(
      id: id,
      provider: provider,
      status: status,
      iframeUrl: iframeUrl,
      providerReference: providerReference,
      providerConfig: providerConfig?.toEntity(),
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
