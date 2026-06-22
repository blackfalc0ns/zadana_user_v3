// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_reset_otp_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyResetOtpRequestDto _$VerifyResetOtpRequestDtoFromJson(
  Map<String, dynamic> json,
) => VerifyResetOtpRequestDto(
  identifier: json['identifier'] as String,
  otpCode: json['otpCode'] as String,
);

Map<String, dynamic> _$VerifyResetOtpRequestDtoToJson(
  VerifyResetOtpRequestDto instance,
) => <String, dynamic>{
  'identifier': instance.identifier,
  'otpCode': instance.otpCode,
};
