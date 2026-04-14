import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/profile/domain/entities/update_profile_request_entity.dart';

part 'update_profile_request_dto.g.dart';

@JsonSerializable()
class UpdateProfileRequestDto {
  final String fullName;
  final String email;
  final String phone;

  const UpdateProfileRequestDto({
    required this.fullName,
    required this.email,
    required this.phone,
  });

  factory UpdateProfileRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileRequestDtoToJson(this);
}

extension UpdateProfileRequestEntityMapper on UpdateProfileRequestEntity {
  UpdateProfileRequestDto toDto() {
    return UpdateProfileRequestDto(
      fullName: fullName,
      email: email,
      phone: phone,
    );
  }
}
