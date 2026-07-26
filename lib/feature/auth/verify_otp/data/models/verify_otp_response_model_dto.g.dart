// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_response_model_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOtpResponseModelDto _$VerifyOtpResponseModelDtoFromJson(
  Map<String, dynamic> json,
) => VerifyOtpResponseModelDto(
  tokens: json['tokens'] == null
      ? null
      : TokensModelVerifyDto.fromJson(json['tokens'] as Map<String, dynamic>),
  user: json['user'] == null
      ? null
      : UserModelVerifyDto.fromJson(json['user'] as Map<String, dynamic>),
  isVerified: json['isVerified'] as bool?,
  message: json['message'] as String?,
  registrationToken: json['registrationToken'] as String?,
);

Map<String, dynamic> _$VerifyOtpResponseModelDtoToJson(
  VerifyOtpResponseModelDto instance,
) => <String, dynamic>{
  'tokens': instance.tokens,
  'user': instance.user,
  'isVerified': instance.isVerified,
  'message': instance.message,
  'registrationToken': instance.registrationToken,
};
