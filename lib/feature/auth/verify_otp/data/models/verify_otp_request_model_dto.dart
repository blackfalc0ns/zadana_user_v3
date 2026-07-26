import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/verify_otp_request_entity.dart';

part 'verify_otp_request_model_dto.g.dart';

/// Verify OTP request model
/// Data layer - DTO
@JsonSerializable()
class VerifyOtpRequestModelDto {
  const VerifyOtpRequestModelDto({
    required this.identifier,
    required this.otpCode,
    required this.registrationToken,
  });

  factory VerifyOtpRequestModelDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpRequestModelDtoFromJson(json);

  /// Convert from entity
  factory VerifyOtpRequestModelDto.fromEntity(VerifyOtpRequestEntity entity) {
    return VerifyOtpRequestModelDto(
      identifier: entity.identifier,
      otpCode: entity.otpCode,
      registrationToken: entity.registrationToken,
    );
  }
  final String identifier;
  final String otpCode;
  final String registrationToken;

  Map<String, dynamic> toJson() => _$VerifyOtpRequestModelDtoToJson(this);
}
