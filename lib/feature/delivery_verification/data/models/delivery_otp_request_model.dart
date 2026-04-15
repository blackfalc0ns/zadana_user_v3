import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/delivery_otp_entity.dart';

part 'delivery_otp_request_model.g.dart';

/// Delivery OTP request model
/// Data layer - DTO
@JsonSerializable()
class DeliveryOtpRequestModel {
  const DeliveryOtpRequestModel({required this.orderId, required this.otpCode});

  factory DeliveryOtpRequestModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryOtpRequestModelFromJson(json);

  /// Convert from entity
  factory DeliveryOtpRequestModel.fromEntity(DeliveryOtpEntity entity) {
    return DeliveryOtpRequestModel(
      orderId: entity.orderId,
      otpCode: entity.otpCode,
    );
  }
  final String orderId;
  final String otpCode;

  Map<String, dynamic> toJson() => _$DeliveryOtpRequestModelToJson(this);
}
