import 'package:json_annotation/json_annotation.dart';

part 'register_request_dto.g.dart';

@JsonSerializable()
class RegisterRequestDto {
   final String fullName;
  final String email;
  final String phone;
  final String password;
  final String addressLine;
  final String label;
  final String buildingNo;
  final String floorNo;
  final String apartmentNo;
  final String city;
  final String area;
  final double latitude;
  final double longitude;

  RegisterRequestDto({
     required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.addressLine,
    required this.label,
    required this.buildingNo,
    required this.floorNo,
    required this.apartmentNo,
    required this.city,
    required this.area,
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
