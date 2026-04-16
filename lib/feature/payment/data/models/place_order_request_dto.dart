import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_request_entity.dart';

class PlaceOrderRequestDto {
  const PlaceOrderRequestDto({
    required this.addressId,
    required this.deliverySlotId,
    required this.paymentMethod,
    required this.promoCode,
    this.notes,
  });

  final String addressId;
  final String deliverySlotId;
  final String paymentMethod;
  final String promoCode;
  final String? notes;

  Map<String, dynamic> toJson() {
    return {
      'address_id': addressId,
      'delivery_slot_id': deliverySlotId,
      'payment_method': paymentMethod,
      'promo_code': promoCode,
      'notes': notes,
    };
  }
}

extension PlaceOrderRequestMapper on PlaceOrderRequestEntity {
  PlaceOrderRequestDto toDto() {
    return PlaceOrderRequestDto(
      addressId: addressId,
      deliverySlotId: deliverySlotId,
      paymentMethod: paymentMethod,
      promoCode: promoCode,
      notes: notes,
    );
  }
}
