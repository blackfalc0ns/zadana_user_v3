import 'package:json_annotation/json_annotation.dart';

part 'clear_cart_response_dto.g.dart';

@JsonSerializable()
class ClearCartResponseDto {
  const ClearCartResponseDto({required this.message});

  final String message;

  factory ClearCartResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ClearCartResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ClearCartResponseDtoToJson(this);
}
