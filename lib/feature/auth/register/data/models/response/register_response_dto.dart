import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/auth/register/data/models/response/user_model_register_dto.dart';

part 'register_response_dto.g.dart';

@JsonSerializable()
class RegisterResponseDto {
  RegisterResponseDto({
    this.user,
    this.isVerified,
    this.message,
    this.registrationToken,
  });

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseDtoFromJson(json);
  final UserModelRegisterDto? user;
  final bool? isVerified;
  final String? message;
  final String? registrationToken;

  Map<String, dynamic> toJson() => _$RegisterResponseDtoToJson(this);
}
