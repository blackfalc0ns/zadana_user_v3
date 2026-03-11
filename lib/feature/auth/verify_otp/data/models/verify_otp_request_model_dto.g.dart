// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_request_model_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOtpRequestModelDto _$VerifyOtpRequestModelDtoFromJson(
  Map<String, dynamic> json,
) => VerifyOtpRequestModelDto(
  identifier: json['identifier'] as String,
  otpCode: json['otpCode'] as String,
);

Map<String, dynamic> _$VerifyOtpRequestModelDtoToJson(
  VerifyOtpRequestModelDto instance,
) => <String, dynamic>{
  'identifier': instance.identifier,
  'otpCode': instance.otpCode,
};
