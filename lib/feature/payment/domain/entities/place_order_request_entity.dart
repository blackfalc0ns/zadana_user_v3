class PlaceOrderRequestEntity {
  const PlaceOrderRequestEntity({
    this.vendorId,
    required this.addressId,
    required this.deliverySlotId,
    required this.paymentMethod,
    required this.promoCode,
    this.notes,
    this.removeUnavailableItems = false,
  });

  final String? vendorId;
  final String addressId;
  final String deliverySlotId;
  final String paymentMethod;
  final String promoCode;
  final String? notes;
  final bool removeUnavailableItems;
}
