import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/login_request_entity.dart';

part 'login_request_model_dto.g.dart';

/// Login request model
/// Data layer - DTO
@JsonSerializable()
class LoginRequestModelDto {
  const LoginRequestModelDto({
    required this.identifier,
    required this.password,
  });

  factory LoginRequestModelDto.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelDtoFromJson(json);

  /// Convert from entity
  factory LoginRequestModelDto.fromEntity(LoginRequestEntity entity) {
    return LoginRequestModelDto(
      identifier: entity.identifier,
      password: entity.password,
    );
  }
  final String identifier;
  final String password;

  Map<String, dynamic> toJson() => _$LoginRequestModelDtoToJson(this);
}
