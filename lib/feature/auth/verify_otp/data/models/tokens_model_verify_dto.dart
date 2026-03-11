import 'package:json_annotation/json_annotation.dart';

part 'tokens_model_verify_dto.g.dart';

@JsonSerializable()
class TokensModelVerifyDto {
  final String accessToken;
  final String refreshToken;

  TokensModelVerifyDto({
    required this.accessToken,
    required this.refreshToken,
  });

  factory TokensModelVerifyDto.fromJson(Map<String, dynamic> json) =>
      _$TokensModelVerifyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TokensModelVerifyDtoToJson(this);
}