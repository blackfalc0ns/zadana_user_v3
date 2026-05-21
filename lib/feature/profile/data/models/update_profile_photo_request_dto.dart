import 'package:json_annotation/json_annotation.dart';

part 'update_profile_photo_request_dto.g.dart';

@JsonSerializable()
class UpdateProfilePhotoRequestDto {
  const UpdateProfilePhotoRequestDto({required this.profilePhotoUrl});

  factory UpdateProfilePhotoRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfilePhotoRequestDtoFromJson(json);
  final String profilePhotoUrl;

  Map<String, dynamic> toJson() => _$UpdateProfilePhotoRequestDtoToJson(this);
}
