class PlaceOrderRequestEntity {
  const PlaceOrderRequestEntity({
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
}
