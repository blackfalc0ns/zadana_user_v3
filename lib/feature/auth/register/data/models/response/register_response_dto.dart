import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/auth/register/data/models/response/user_model_register_dto.dart';

part 'register_response_dto.g.dart';

@JsonSerializable()
class RegisterResponseDto {
  final UserModelRegisterDto? user;
  final bool? isVerified;
  final String? message;
  RegisterResponseDto({this.user, this.isVerified, this.message});

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseDtoToJson(this);
}
