import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/favorites_summary_dto.dart';

part 'remove_favorite_response_dto.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class RemoveFavoriteResponseDto {
  const RemoveFavoriteResponseDto({
    required this.message,
    required this.summary,
  });

  factory RemoveFavoriteResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RemoveFavoriteResponseDtoFromJson(json);

  @JsonKey(defaultValue: '')
  final String message;

  @JsonKey(fromJson: _favoritesSummaryFromJson)
  final FavoritesSummaryDto summary;

  Map<String, dynamic> toJson() => _$RemoveFavoriteResponseDtoToJson(this);
}

FavoritesSummaryDto _favoritesSummaryFromJson(Map<String, dynamic>? json) =>
    FavoritesSummaryDto.fromJson(json ?? const {});
