import 'package:json_annotation/json_annotation.dart';

part 'verify_reset_otp_request_dto.g.dart';

@JsonSerializable()
class VerifyResetOtpRequestDto {
  VerifyResetOtpRequestDto({
    required this.identifier,
    required this.otpCode,
  });

  factory VerifyResetOtpRequestDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyResetOtpRequestDtoFromJson(json);
  final String identifier;
  final String otpCode;

  Map<String, dynamic> toJson() => _$VerifyResetOtpRequestDtoToJson(this);
}
