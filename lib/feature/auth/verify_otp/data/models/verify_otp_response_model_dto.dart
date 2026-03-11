import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/data/models/tokens_model_verify_dto.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/data/models/user_model_verify_dto.dart';
import '../../domain/entities/verify_otp_response_entity.dart';

part 'verify_otp_response_model_dto.g.dart';

/// Verify OTP response model
/// Data layer - DTO
@JsonSerializable()
class VerifyOtpResponseModelDto {
  final TokensModelVerifyDto? tokens;
  final UserModelVerifyDto? user;
  final bool? isVerified;
  final String? message;

  const VerifyOtpResponseModelDto({
    this.tokens,
    this.user,
    this.isVerified,
    this.message,
  });

  factory VerifyOtpResponseModelDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseModelDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpResponseModelDtoToJson(this);

  /// Convert to entity
  VerifyOtpResponseEntity toEntity() {
    return VerifyOtpResponseEntity(
      user: user?.toEntity(),
      isVerified: isVerified ?? false,
      message: message ?? '',
    );
  }
}
