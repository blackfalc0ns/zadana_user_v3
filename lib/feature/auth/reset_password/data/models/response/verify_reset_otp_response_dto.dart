import 'package:json_annotation/json_annotation.dart';

part 'verify_reset_otp_response_dto.g.dart';

@JsonSerializable()
class VerifyResetOtpResponseDto {
  VerifyResetOtpResponseDto({required this.resetToken, this.message});

  factory VerifyResetOtpResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyResetOtpResponseDtoFromJson(json);
  final String resetToken;
  final String? message;

  Map<String, dynamic> toJson() => _$VerifyResetOtpResponseDtoToJson(this);
}
