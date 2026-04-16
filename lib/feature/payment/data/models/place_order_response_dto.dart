import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_response_entity.dart';

class PlaceOrderResponseDto {
  const PlaceOrderResponseDto({
    required this.message,
    required this.order,
    this.payment,
  });

  factory PlaceOrderResponseDto.fromJson(Map<String, dynamic> json) {
    return PlaceOrderResponseDto(
      message: json['message']?.toString() ?? '',
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
  });

  factory OrderPaymentDto.fromJson(Map<String, dynamic> json) {
    return OrderPaymentDto(
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

  OrderPaymentEntity toEntity() {
    return OrderPaymentEntity(
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

Map<String, dynamic>? _nullableMap(dynamic value) {
  return value is Map<String, dynamic> ? value : null;
}

double _asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
