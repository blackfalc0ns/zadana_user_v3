// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordRequestDto _$ResetPasswordRequestDtoFromJson(
  Map<String, dynamic> json,
) => ResetPasswordRequestDto(
  identifier: json['identifier'] as String,
  resetToken: json['resetToken'] as String,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$ResetPasswordRequestDtoToJson(
  ResetPasswordRequestDto instance,
) => <String, dynamic>{
  'identifier': instance.identifier,
  'resetToken': instance.resetToken,
  'newPassword': instance.newPassword,
};
