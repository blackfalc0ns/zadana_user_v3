import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_config_entity.dart';

class CheckoutConfigDto {
  const CheckoutConfigDto({
    required this.deliveryEnabled,
    required this.pickupEnabled,
    required this.pickupCashOnPickupEnabled,
    required this.allowedPaymentsForPickup,
  });

  factory CheckoutConfigDto.fromJson(Map<String, dynamic> json) {
    return CheckoutConfigDto(
      deliveryEnabled: json['delivery_enabled'] == true,
      pickupEnabled: json['pickup_enabled'] == true,
      pickupCashOnPickupEnabled: json['pickup_cash_on_pickup_enabled'] == true,
      allowedPaymentsForPickup: (json['allowed_payments_for_pickup'] as List?)
              ?.map((item) => item?.toString() ?? '')
              .where((item) => item.isNotEmpty)
              .toList() ??
          const [],
    );
  }

  final bool deliveryEnabled;
  final bool pickupEnabled;
  final bool pickupCashOnPickupEnabled;
  final List<String> allowedPaymentsForPickup;

  CheckoutConfigEntity toEntity() {
    return CheckoutConfigEntity(
      deliveryEnabled: deliveryEnabled,
      pickupEnabled: pickupEnabled,
      pickupCashOnPickupEnabled: pickupCashOnPickupEnabled,
      allowedPaymentsForPickup: allowedPaymentsForPickup,
    );
  }
}
