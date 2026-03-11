// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_model_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequestModelDto _$LoginRequestModelDtoFromJson(
  Map<String, dynamic> json,
) => LoginRequestModelDto(
  identifier: json['identifier'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$LoginRequestModelDtoToJson(
  LoginRequestModelDto instance,
) => <String, dynamic>{
  'identifier': instance.identifier,
  'password': instance.password,
};
