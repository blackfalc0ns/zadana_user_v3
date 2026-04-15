import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/tokens_entity.dart';

part 'tokens_model_dto.g.dart';

/// Tokens model
/// Data layer - DTO
@JsonSerializable()
class TokensModelDto {
  const TokensModelDto({required this.accessToken, this.refreshToken});

  factory TokensModelDto.fromJson(Map<String, dynamic> json) =>
      _$TokensModelDtoFromJson(json);
  final String accessToken;
  final String? refreshToken;

  Map<String, dynamic> toJson() => _$TokensModelDtoToJson(this);

  /// Convert to entity
  TokensEntity toEntity() {
    return TokensEntity(accessToken: accessToken, refreshToken: refreshToken);
  }
}
