import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/domain/entities/user_model_verify_entity.dart';

part 'user_model_verify_dto.g.dart';

@JsonSerializable()
class UserModelVerifyDto {
  UserModelVerifyDto({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory UserModelVerifyDto.fromJson(Map<String, dynamic> json) =>
      _$UserModelVerifyDtoFromJson(json);
  final String? id;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? role;

  Map<String, dynamic> toJson() => _$UserModelVerifyDtoToJson(this);

  UserModelVerifyEntity toEntity() {
    return UserModelVerifyEntity(
      id: id ?? '',
      fullName: fullName ?? '',
      email: email ?? '',
      phone: phone ?? '',
      role: role ?? '',
    );
  }
}
