import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/verify_otp_request_entity.dart';

part 'verify_otp_request_model_dto.g.dart';

/// Verify OTP request model
/// Data layer - DTO
@JsonSerializable()
class VerifyOtpRequestModelDto {
  final String identifier;
  final String otpCode;

  const VerifyOtpRequestModelDto({
    required this.identifier,
    required this.otpCode,
  });

  factory VerifyOtpRequestModelDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpRequestModelDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpRequestModelDtoToJson(this);

  /// Convert from entity
  factory VerifyOtpRequestModelDto.fromEntity(VerifyOtpRequestEntity entity) {
    return VerifyOtpRequestModelDto(
      identifier: entity.identifier,
      otpCode: entity.otpCode,
    );
  }
}
