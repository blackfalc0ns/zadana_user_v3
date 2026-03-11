// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tokens_model_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokensModelDto _$TokensModelDtoFromJson(Map<String, dynamic> json) =>
    TokensModelDto(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$TokensModelDtoToJson(TokensModelDto instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
