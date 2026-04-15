import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/login_response_entity.dart';
import 'tokens_model_dto.dart';
import 'user_model_dto.dart';

part 'login_response_model_dto.g.dart';

/// Login response model
/// Data layer - DTO
@JsonSerializable()
class LoginResponseModelDto {
  const LoginResponseModelDto({required this.tokens, required this.user});

  factory LoginResponseModelDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelDtoFromJson(json);
  final TokensModelDto tokens;
  final UserModelDto user;

  Map<String, dynamic> toJson() => _$LoginResponseModelDtoToJson(this);

  /// Convert to entity
  LoginResponseEntity toEntity() {
    return LoginResponseEntity(
      tokens: tokens.toEntity(),
      user: user.toEntity(),
    );
  }
}
