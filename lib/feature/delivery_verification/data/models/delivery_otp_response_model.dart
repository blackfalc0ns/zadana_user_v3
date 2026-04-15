import 'package:json_annotation/json_annotation.dart';

part 'delivery_otp_response_model.g.dart';

/// Delivery OTP response model
@JsonSerializable()
class DeliveryOtpResponseModel {
  const DeliveryOtpResponseModel({required this.success, this.message});

  factory DeliveryOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryOtpResponseModelFromJson(json);
  final bool success;
  final String? message;

  Map<String, dynamic> toJson() => _$DeliveryOtpResponseModelToJson(this);
}
