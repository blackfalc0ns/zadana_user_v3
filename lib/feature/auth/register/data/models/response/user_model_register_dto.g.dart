// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model_register_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModelRegisterDto _$UserModelRegisterDtoFromJson(
  Map<String, dynamic> json,
) => UserModelRegisterDto(
  id: json['id'] as String,
  fullName: json['fullName'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  role: json['role'] as String,
);

Map<String, dynamic> _$UserModelRegisterDtoToJson(
  UserModelRegisterDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'email': instance.email,
  'phone': instance.phone,
  'role': instance.role,
};
