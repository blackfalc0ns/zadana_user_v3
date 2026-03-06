import 'package:json_annotation/json_annotation.dart';

part 'register_request_dto.g.dart';

@JsonSerializable()
class RegisterRequestDto {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String address;
  final double latitude;
  final double longitude;

  RegisterRequestDto({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory RegisterRequestDto.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$RegisterRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => 
      _$RegisterRequestDtoToJson(this);
}
