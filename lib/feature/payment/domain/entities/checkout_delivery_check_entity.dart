/// Delivery check result embedded in the checkout summary response.
///
/// This is the source of truth for whether delivery is possible and whether
/// checkout can continue.
class CheckoutDeliveryCheckEntity {
  const CheckoutDeliveryCheckEntity({
    required this.status,
    required this.isDeliverable,
    required this.canProceedToCheckout,
    required this.messageAr,
    required this.messageEn,
    this.deliveryFee,
    this.distanceKm,
  });

  final String status;
  final bool isDeliverable;
  final bool canProceedToCheckout;
  final String messageAr;
  final String messageEn;
  final double? deliveryFee;
  final double? distanceKm;
}
