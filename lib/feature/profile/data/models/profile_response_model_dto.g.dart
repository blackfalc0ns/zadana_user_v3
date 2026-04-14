// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response_model_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponseModelDto _$ProfileResponseModelDtoFromJson(
  Map<String, dynamic> json,
) => ProfileResponseModelDto(
  id: json['id'] as String,
  fullName: json['fullName'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  role: json['role'] as String,
  favoritesCount: (json['favoritesCount'] as num).toInt(),
);

Map<String, dynamic> _$ProfileResponseModelDtoToJson(
  ProfileResponseModelDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'email': instance.email,
  'phone': instance.phone,
  'role': instance.role,
  'favoritesCount': instance.favoritesCount,
};
