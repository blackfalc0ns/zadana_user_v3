import 'package:json_annotation/json_annotation.dart';

part 'tokens_model_verify_dto.g.dart';

@JsonSerializable()
class TokensModelVerifyDto {
  TokensModelVerifyDto({required this.accessToken, required this.refreshToken});

  factory TokensModelVerifyDto.fromJson(Map<String, dynamic> json) =>
      _$TokensModelVerifyDtoFromJson(json);
  final String accessToken;
  final String refreshToken;

  Map<String, dynamic> toJson() => _$TokensModelVerifyDtoToJson(this);
}
