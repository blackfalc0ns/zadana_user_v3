// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tokens_model_verify_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokensModelVerifyDto _$TokensModelVerifyDtoFromJson(
  Map<String, dynamic> json,
) => TokensModelVerifyDto(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
);

Map<String, dynamic> _$TokensModelVerifyDtoToJson(
  TokensModelVerifyDto instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
};
