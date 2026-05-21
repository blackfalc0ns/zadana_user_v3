import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model_dto.g.dart';

/// User model
/// Data layer - DTO
@JsonSerializable()
class UserModelDto {
  const UserModelDto({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.profilePhotoUrl,
  });

  factory UserModelDto.fromJson(Map<String, dynamic> json) =>
      _$UserModelDtoFromJson(json);
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String? profilePhotoUrl;

  Map<String, dynamic> toJson() => _$UserModelDtoToJson(this);

  /// Convert to entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      fullName: fullName,
      email: email,
      phone: phone,
      role: role,
      profilePhotoUrl: profilePhotoUrl,
    );
  }
}
