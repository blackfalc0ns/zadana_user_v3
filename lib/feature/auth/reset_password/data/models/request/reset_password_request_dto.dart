import 'package:json_annotation/json_annotation.dart';

part 'reset_password_request_dto.g.dart';

@JsonSerializable()
class ResetPasswordRequestDto {
  ResetPasswordRequestDto({
    required this.identifier,
    required this.resetToken,
    required this.newPassword,
  });

  factory ResetPasswordRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestDtoFromJson(json);
  final String identifier;
  final String resetToken;
  final String newPassword;

  Map<String, dynamic> toJson() => _$ResetPasswordRequestDtoToJson(this);
}
