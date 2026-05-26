import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_request_entity.dart';

class PlaceOrderRequestDto {
  const PlaceOrderRequestDto({
    this.vendorId,
    required this.addressId,
    required this.deliverySlotId,
    required this.paymentMethod,
    required this.promoCode,
    this.notes,
  });

  final String? vendorId;
  final String addressId;
  final String deliverySlotId;
  final String paymentMethod;
  final String promoCode;
  final String? notes;

  Map<String, dynamic> toJson() {
    return {
      'vendor_id': vendorId,
      'address_id': addressId,
      'delivery_slot_id': deliverySlotId,
      'payment_method': _normalizePaymentMethod(paymentMethod),
      'promo_code': promoCode,
      'notes': notes,
    };
  }
}

extension PlaceOrderRequestMapper on PlaceOrderRequestEntity {
  PlaceOrderRequestDto toDto() {
    return PlaceOrderRequestDto(
      vendorId: vendorId,
      addressId: addressId,
      deliverySlotId: deliverySlotId,
      paymentMethod: paymentMethod,
      promoCode: promoCode,
      notes: notes,
    );
  }
}

String _normalizePaymentMethod(String value) {
  final normalized = value.trim().toLowerCase();
  switch (normalized) {
    case 'cash_on_delivery':
    case 'cod':
      return 'cash';
    case 'credit_card':
    case 'debit_card':
    case 'mada':
      return 'card';
    default:
      return normalized;
  }
}
