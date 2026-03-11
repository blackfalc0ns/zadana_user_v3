import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/tokens_entity.dart';

part 'tokens_model_dto.g.dart';

/// Tokens model
/// Data layer - DTO
@JsonSerializable()
class TokensModelDto {
  final String accessToken;
  final String refreshToken;

  const TokensModelDto({
    required this.accessToken,
    required this.refreshToken,
  });

  factory TokensModelDto.fromJson(Map<String, dynamic> json) =>
      _$TokensModelDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TokensModelDtoToJson(this);

  /// Convert to entity
  TokensEntity toEntity() {
    return TokensEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}