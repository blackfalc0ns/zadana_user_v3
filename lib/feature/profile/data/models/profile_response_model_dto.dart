import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/profile_response_entity.dart';

part 'profile_response_model_dto.g.dart';

/// Profile response model
/// Data layer - DTO
@JsonSerializable()
class ProfileResponseModelDto {
  const ProfileResponseModelDto({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.favoritesCount,
    this.profilePhotoUrl,
  });

  factory ProfileResponseModelDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseModelDtoFromJson(json);
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final int favoritesCount;
  final String? profilePhotoUrl;

  Map<String, dynamic> toJson() => _$ProfileResponseModelDtoToJson(this);

  /// Convert to entity
  ProfileResponseEntity toEntity() {
    return ProfileResponseEntity(
      id: id,
      fullName: fullName,
      email: email,
      phone: phone,
      role: role,
      favoritesCount: favoritesCount,
      profilePhotoUrl: profilePhotoUrl,
    );
  }
}
