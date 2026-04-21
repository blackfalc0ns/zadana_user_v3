import 'package:json_annotation/json_annotation.dart';

part 'clear_favorites_response_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ClearFavoritesResponseDto {
  const ClearFavoritesResponseDto({required this.message});

  factory ClearFavoritesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ClearFavoritesResponseDtoFromJson(json);

  @JsonKey(defaultValue: '')
  final String message;

  Map<String, dynamic> toJson() => _$ClearFavoritesResponseDtoToJson(this);
}
