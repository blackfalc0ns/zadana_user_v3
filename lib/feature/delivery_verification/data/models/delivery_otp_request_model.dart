import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/delivery_otp_entity.dart';

part 'delivery_otp_request_model.g.dart';

/// Delivery OTP request model
/// Data layer - DTO
@JsonSerializable()
class DeliveryOtpRequestModel {
  final String orderId;
  final String otpCode;

  const DeliveryOtpRequestModel({
    required this.orderId,
    required this.otpCode,
  });

  factory DeliveryOtpRequestModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryOtpRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryOtpRequestModelToJson(this);

  /// Convert from entity
  factory DeliveryOtpRequestModel.fromEntity(DeliveryOtpEntity entity) {
    return DeliveryOtpRequestModel(
      orderId: entity.orderId,
      otpCode: entity.otpCode,
    );
  }
}