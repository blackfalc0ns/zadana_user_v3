import 'package:json_annotation/json_annotation.dart';

part 'reset_password_response_dto.g.dart';

@JsonSerializable()
class ResetPasswordResponseDto {
  ResetPasswordResponseDto({required this.message});

  factory ResetPasswordResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseDtoFromJson(json);
  final String message;

  Map<String, dynamic> toJson() => _$ResetPasswordResponseDtoToJson(this);
}
