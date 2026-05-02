import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/core/utils/localized_api_message.dart';

part 'clear_cart_response_dto.g.dart';

@JsonSerializable()
class ClearCartResponseDto {
  factory ClearCartResponseDto.fromJson(Map<String, dynamic> json) =>
      ClearCartResponseDto(message: resolveLocalizedApiMessage(json));
  const ClearCartResponseDto({required this.message});

  final String message;

  Map<String, dynamic> toJson() => _$ClearCartResponseDtoToJson(this);
}
