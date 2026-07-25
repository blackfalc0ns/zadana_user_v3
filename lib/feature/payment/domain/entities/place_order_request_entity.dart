class PlaceOrderRequestEntity {
  const PlaceOrderRequestEntity({
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
}
