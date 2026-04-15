import 'package:json_annotation/json_annotation.dart';

part 'logout_request_dto.g.dart';

@JsonSerializable()
class LogoutRequestDto {
  const LogoutRequestDto({required this.refreshToken});

  factory LogoutRequestDto.fromJson(Map<String, dynamic> json) =>
      _$LogoutRequestDtoFromJson(json);
  final String refreshToken;

  Map<String, dynamic> toJson() => _$LogoutRequestDtoToJson(this);
}
