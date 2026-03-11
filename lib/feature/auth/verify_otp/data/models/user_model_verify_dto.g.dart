// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model_verify_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModelVerifyDto _$UserModelVerifyDtoFromJson(Map<String, dynamic> json) =>
    UserModelVerifyDto(
      id: json['id'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$UserModelVerifyDtoToJson(UserModelVerifyDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'role': instance.role,
    };
