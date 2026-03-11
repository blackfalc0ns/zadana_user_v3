// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponseModelDto _$LoginResponseModelDtoFromJson(
  Map<String, dynamic> json,
) => LoginResponseModelDto(
  tokens: TokensModelDto.fromJson(json['tokens'] as Map<String, dynamic>),
  user: UserModelDto.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LoginResponseModelDtoToJson(
  LoginResponseModelDto instance,
) => <String, dynamic>{'tokens': instance.tokens, 'user': instance.user};
