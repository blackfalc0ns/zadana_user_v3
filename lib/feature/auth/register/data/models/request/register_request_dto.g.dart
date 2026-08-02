// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterRequestDto _$RegisterRequestDtoFromJson(Map<String, dynamic> json) =>
    RegisterRequestDto(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      password: json['password'] as String,
      addressLine: json['addressLine'] as String,
      label: json['label'] as String,
      buildingNo: json['buildingNo'] as String,
      floorNo: json['floorNo'] as String,
      apartmentNo: json['apartmentNo'] as String,
      city: json['city'] as String,
      area: json['area'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$RegisterRequestDtoToJson(RegisterRequestDto instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
      if (instance.phone case final value?) 'phone': value,
      'password': instance.password,
      'addressLine': instance.addressLine,
      'label': instance.label,
      'buildingNo': instance.buildingNo,
      'floorNo': instance.floorNo,
      'apartmentNo': instance.apartmentNo,
      'city': instance.city,
      'area': instance.area,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
