import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_request_entity.dart';

class PlaceOrderRequestDto {
  const PlaceOrderRequestDto({
    this.vendorId,
    this.fulfillmentType = 'delivery',
    this.addressId,
    this.deliverySlotId,
    this.vendorBranchId,
    required this.paymentMethod,
    required this.promoCode,
    this.notes,
    this.removeUnavailableItems = false,
  });

  final String? vendorId;
  final String fulfillmentType;
  final String? addressId;
  final String? deliverySlotId;
  final String? vendorBranchId;
  final String paymentMethod;
  final String promoCode;
  final String? notes;
  final bool removeUnavailableItems;

  Map<String, dynamic> toJson() {
    return {
      'vendor_id': vendorId,
      'fulfillment_type': fulfillmentType,
      if (addressId != null && addressId!.isNotEmpty) 'address_id': addressId,
      if (deliverySlotId != null && deliverySlotId!.isNotEmpty)
        'delivery_slot_id': deliverySlotId,
      if (vendorBranchId != null && vendorBranchId!.isNotEmpty)
        'vendor_branch_id': vendorBranchId,
      'payment_method': _normalizePaymentMethod(paymentMethod),
      'promo_code': promoCode,
      'notes': notes,
      if (removeUnavailableItems) 'remove_unavailable_items': true,
    };
  }
}

extension PlaceOrderRequestMapper on PlaceOrderRequestEntity {
  PlaceOrderRequestDto toDto() {
    return PlaceOrderRequestDto(
      vendorId: vendorId,
      fulfillmentType: fulfillmentType,
      addressId: addressId,
      deliverySlotId: deliverySlotId,
      vendorBranchId: vendorBranchId,
      paymentMethod: paymentMethod,
      promoCode: promoCode,
      notes: notes,
      removeUnavailableItems: removeUnavailableItems,
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
