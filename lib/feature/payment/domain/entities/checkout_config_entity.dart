class CheckoutConfigEntity {
  const CheckoutConfigEntity({
    required this.deliveryEnabled,
    required this.pickupEnabled,
    required this.pickupCashOnPickupEnabled,
    required this.allowedPaymentsForPickup,
  });

  final bool deliveryEnabled;
  final bool pickupEnabled;
  final bool pickupCashOnPickupEnabled;
  final List<String> allowedPaymentsForPickup;
}
