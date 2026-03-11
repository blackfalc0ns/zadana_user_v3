// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterResponseDto _$RegisterResponseDtoFromJson(Map<String, dynamic> json) =>
    RegisterResponseDto(
      user: json['user'] == null
          ? null
          : UserModelRegisterDto.fromJson(json['user'] as Map<String, dynamic>),
      isVerified: json['isVerified'] as bool?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$RegisterResponseDtoToJson(
  RegisterResponseDto instance,
) => <String, dynamic>{
  'user': instance.user,
  'isVerified': instance.isVerified,
  'message': instance.message,
};
