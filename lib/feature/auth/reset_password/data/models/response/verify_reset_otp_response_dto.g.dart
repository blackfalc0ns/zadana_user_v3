// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_reset_otp_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyResetOtpResponseDto _$VerifyResetOtpResponseDtoFromJson(
  Map<String, dynamic> json,
) => VerifyResetOtpResponseDto(
  resetToken: json['resetToken'] as String,
  message: json['message'] as String?,
);

Map<String, dynamic> _$VerifyResetOtpResponseDtoToJson(
  VerifyResetOtpResponseDto instance,
) => <String, dynamic>{
  'resetToken': instance.resetToken,
  'message': instance.message,
};
