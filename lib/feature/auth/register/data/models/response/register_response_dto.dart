import 'package:json_annotation/json_annotation.dart';

part 'register_response_dto.g.dart';

@JsonSerializable()
class RegisterResponseDto {
  final String message;
  final String? userId;

  RegisterResponseDto({
    required this.message,
    this.userId,
  });

  factory RegisterResponseDto.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$RegisterResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => 
      _$RegisterResponseDtoToJson(this);
}
