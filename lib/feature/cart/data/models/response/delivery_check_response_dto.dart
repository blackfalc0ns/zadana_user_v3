import 'package:zadana_user_v3/feature/cart/domain/entities/delivery_check_entity.dart';

class DeliveryCheckResponseDto {
  const DeliveryCheckResponseDto({
    required this.status,
    required this.isDeliverable,
    required this.canProceedToCheckout,
    required this.messageAr,
    required this.messageEn,
    this.deliveryFee,
    this.distanceKm,
  });

  factory DeliveryCheckResponseDto.fromJson(Map<String, dynamic> json) {
    return DeliveryCheckResponseDto(
      status: json['status']?.toString() ?? '',
      isDeliverable: json['is_deliverable'] == true,
      canProceedToCheckout: json['can_proceed_to_checkout'] == true,
      messageAr: json['message_ar']?.toString() ??
          json['message']?.toString() ??
          '',
      messageEn: json['message_en']?.toString() ??
          json['message']?.toString() ??
          '',
      deliveryFee: _asNullableDouble(json['delivery_fee']),
      distanceKm: _asNullableDouble(json['distance_km']),
    );
  }

  final String status;
  final bool isDeliverable;
  final bool canProceedToCheckout;
  final String messageAr;
  final String messageEn;
  final double? deliveryFee;
  final double? distanceKm;

  DeliveryCheckEntity toEntity() {
    return DeliveryCheckEntity(
      status: status,
      isDeliverable: isDeliverable,
      canProceedToCheckout: canProceedToCheckout,
      messageAr: messageAr,
      messageEn: messageEn,
      deliveryFee: deliveryFee,
      distanceKm: distanceKm,
    );
  }
}

double? _asNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
