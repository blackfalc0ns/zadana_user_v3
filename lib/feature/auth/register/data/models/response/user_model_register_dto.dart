import 'package:json_annotation/json_annotation.dart';

part 'user_model_register_dto.g.dart';

@JsonSerializable()
class UserModelRegisterDto {
  UserModelRegisterDto({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory UserModelRegisterDto.fromJson(Map<String, dynamic> json) =>
      _$UserModelRegisterDtoFromJson(json);
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;

  Map<String, dynamic> toJson() => _$UserModelRegisterDtoToJson(this);
}
