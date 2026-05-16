/// Represents the result of a delivery eligibility pre-check.
///
/// Used to validate whether delivery is possible for a given vendor + address
/// combination before entering checkout.
class DeliveryCheckEntity {
  const DeliveryCheckEntity({
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
