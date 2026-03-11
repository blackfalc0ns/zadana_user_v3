// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordRequestDto _$ResetPasswordRequestDtoFromJson(
  Map<String, dynamic> json,
) => ResetPasswordRequestDto(
  identifier: json['identifier'] as String,
  otpCode: json['otpCode'] as String,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$ResetPasswordRequestDtoToJson(
  ResetPasswordRequestDto instance,
) => <String, dynamic>{
  'identifier': instance.identifier,
  'otpCode': instance.otpCode,
  'newPassword': instance.newPassword,
};
