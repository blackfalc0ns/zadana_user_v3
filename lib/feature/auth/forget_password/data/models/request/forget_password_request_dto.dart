import 'package:json_annotation/json_annotation.dart';

part 'forget_password_request_dto.g.dart';

@JsonSerializable()
class ForgetPasswordRequestDto {
  ForgetPasswordRequestDto({required this.identifier});

  factory ForgetPasswordRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ForgetPasswordRequestDtoFromJson(json);
  final String identifier;

  Map<String, dynamic> toJson() => _$ForgetPasswordRequestDtoToJson(this);
}
