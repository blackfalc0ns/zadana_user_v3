import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';

class CheckoutSummaryDto {
  const CheckoutSummaryDto({
    required this.cart,
    required this.deliverySlots,
    required this.paymentMethods,
    required this.summary,
    this.selectedAddress,
    this.promoCode,
  });

  factory CheckoutSummaryDto.fromJson(Map<String, dynamic> json) {
    return CheckoutSummaryDto(
      cart: CheckoutCartDto.fromJson(_asMap(json['cart'])),
      selectedAddress: _nullableMap(json['selected_address']) == null
          ? null
          : CheckoutAddressDto.fromJson(_asMap(json['selected_address'])),
      deliverySlots: _asList(json['delivery_slots'])
          .map((item) => CheckoutDeliverySlotDto.fromJson(_asMap(item)))
          .toList(),
      paymentMethods: _asList(json['payment_methods'])
          .map((item) => CheckoutPaymentMethodDto.fromJson(_asMap(item)))
          .toList(),
      promoCode: _nullableMap(json['promo_code']) == null
          ? null
          : CheckoutPromoCodeDto.fromJson(_asMap(json['promo_code'])),
      summary: CheckoutTotalsDto.fromJson(_asMap(json['summary'])),
    );
  }

  final CheckoutCartDto cart;
  final CheckoutAddressDto? selectedAddress;
  final List<CheckoutDeliverySlotDto> deliverySlots;
  final List<CheckoutPaymentMethodDto> paymentMethods;
  final CheckoutPromoCodeDto? promoCode;
  final CheckoutTotalsDto summary;

  CheckoutSummaryEntity toEntity() {
    return CheckoutSummaryEntity(
      cart: cart.toEntity(),
      selectedAddress: selectedAddress?.toEntity(),
      deliverySlots: deliverySlots.map((item) => item.toEntity()).toList(),
      paymentMethods: paymentMethods.map((item) => item.toEntity()).toList(),
      promoCode: promoCode?.toEntity(),
      summary: summary.toEntity(),
    );
  }
}

class CheckoutCartDto {
  const CheckoutCartDto({
    required this.itemsCount,
    required this.totalQuantity,
    required this.items,
  });

  factory CheckoutCartDto.fromJson(Map<String, dynamic> json) {
    return CheckoutCartDto(
      itemsCount: _asInt(json['items_count']),
      totalQuantity: _asInt(json['total_quantity']),
      items: _asList(json['items'])
          .map((item) => CheckoutCartItemDto.fromJson(_asMap(item)))
          .toList(),
    );
  }

  final int itemsCount;
  final int totalQuantity;
  final List<CheckoutCartItemDto> items;

  CheckoutCartEntity toEntity() {
    return CheckoutCartEntity(
      itemsCount: itemsCount,
      totalQuantity: totalQuantity,
      items: items.map((item) => item.toEntity()).toList(),
    );
  }
}

class CheckoutCartItemDto {
  const CheckoutCartItemDto({
    required this.id,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    this.imageUrl,
    this.unit,
  });

  factory CheckoutCartItemDto.fromJson(Map<String, dynamic> json) {
    return CheckoutCartItemDto(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      unit: json['unit']?.toString(),
      quantity: _asInt(json['quantity']),
      price: _asDouble(json['price']),
      totalPrice: _asDouble(json['total_price']),
    );
  }

  final String id;
  final String productId;
  final String name;
  final String? imageUrl;
  final String? unit;
  final int quantity;
  final double price;
  final double totalPrice;

  CheckoutCartItemEntity toEntity() {
    return CheckoutCartItemEntity(
      id: id,
      productId: productId,
      name: name,
      imageUrl: imageUrl,
      unit: unit,
      quantity: quantity,
      price: price,
      totalPrice: totalPrice,
    );
  }
}

class CheckoutAddressDto {
  const CheckoutAddressDto({
    required this.id,
    required this.label,
    required this.addressLine,
    required this.isDefault,
  });

  factory CheckoutAddressDto.fromJson(Map<String, dynamic> json) {
    return CheckoutAddressDto(
      id: json['id']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      addressLine: json['address_line']?.toString() ?? '',
      isDefault: json['is_default'] == true,
    );
  }

  final String id;
  final String label;
  final String addressLine;
  final bool isDefault;

  CheckoutAddressEntity toEntity() {
    return CheckoutAddressEntity(
      id: id,
      label: label,
      addressLine: addressLine,
      isDefault: isDefault,
    );
  }
}

class CheckoutDeliverySlotDto {
  const CheckoutDeliverySlotDto({
    required this.id,
    required this.label,
    required this.startAt,
    required this.endAt,
    required this.isAvailable,
    required this.isSelected,
  });

  factory CheckoutDeliverySlotDto.fromJson(Map<String, dynamic> json) {
    return CheckoutDeliverySlotDto(
      id: json['id']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      startAt: _asDateTime(json['start_at']),
      endAt: _asDateTime(json['end_at']),
      isAvailable: json['is_available'] == true,
      isSelected: json['is_selected'] == true,
    );
  }

  final String id;
  final String label;
  final DateTime startAt;
  final DateTime endAt;
  final bool isAvailable;
  final bool isSelected;

  CheckoutDeliverySlotEntity toEntity() {
    return CheckoutDeliverySlotEntity(
      id: id,
      label: label,
      startAt: startAt,
      endAt: endAt,
      isAvailable: isAvailable,
      isSelected: isSelected,
    );
  }
}

class CheckoutPaymentMethodDto {
  const CheckoutPaymentMethodDto({
    required this.code,
    required this.label,
    required this.isAvailable,
    required this.isDefault,
  });

  factory CheckoutPaymentMethodDto.fromJson(Map<String, dynamic> json) {
    return CheckoutPaymentMethodDto(
      code: json['code']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      isAvailable: json['is_available'] == true,
      isDefault: json['is_default'] == true,
    );
  }

  final String code;
  final String label;
  final bool isAvailable;
  final bool isDefault;

  CheckoutPaymentMethodEntity toEntity() {
    return CheckoutPaymentMethodEntity(
      code: code,
      label: label,
      isAvailable: isAvailable,
      isDefault: isDefault,
    );
  }
}

class CheckoutPromoCodeDto {
  const CheckoutPromoCodeDto({
    required this.code,
    required this.discountType,
    required this.discountValue,
    required this.discountAmount,
  });

  factory CheckoutPromoCodeDto.fromJson(Map<String, dynamic> json) {
    return CheckoutPromoCodeDto(
      code: json['code']?.toString() ?? '',
      discountType: json['discount_type']?.toString() ?? '',
      discountValue: _asDouble(json['discount_value']),
      discountAmount: _asDouble(json['discount_amount']),
    );
  }

  final String code;
  final String discountType;
  final double discountValue;
  final double discountAmount;

  CheckoutPromoCodeEntity toEntity() {
    return CheckoutPromoCodeEntity(
      code: code,
      discountType: discountType,
      discountValue: discountValue,
      discountAmount: discountAmount,
    );
  }
}

class CheckoutTotalsDto {
  const CheckoutTotalsDto({
    required this.subtotal,
    required this.shippingCost,
    required this.discount,
    required this.total,
    required this.currency,
  });

  factory CheckoutTotalsDto.fromJson(Map<String, dynamic> json) {
    return CheckoutTotalsDto(
      subtotal: _asDouble(json['subtotal']),
      shippingCost: _asDouble(json['shipping_cost']),
      discount: _asDouble(json['discount']),
      total: _asDouble(json['total']),
      currency: json['currency']?.toString() ?? '',
    );
  }

  final double subtotal;
  final double shippingCost;
  final double discount;
  final double total;
  final String currency;

  CheckoutTotalsEntity toEntity() {
    return CheckoutTotalsEntity(
      subtotal: subtotal,
      shippingCost: shippingCost,
      discount: discount,
      total: total,
      currency: currency,
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  return value is Map<String, dynamic> ? value : <String, dynamic>{};
}

Map<String, dynamic>? _nullableMap(dynamic value) {
  return value is Map<String, dynamic> ? value : null;
}

List<dynamic> _asList(dynamic value) {
  return value is List ? value : const [];
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

DateTime _asDateTime(dynamic value) {
  return DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
}
