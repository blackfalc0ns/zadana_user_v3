import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/favorites_item_dto.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/favorites_summary_dto.dart';

part 'add_favorite_response_dto.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class AddFavoriteResponseDto {
  const AddFavoriteResponseDto({
    required this.message,
    required this.item,
    required this.summary,
  });

  factory AddFavoriteResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AddFavoriteResponseDtoFromJson(json);

  @JsonKey(defaultValue: '')
  final String message;

  @JsonKey(fromJson: _favoritesItemFromJson)
  final FavoritesItemDto item;

  @JsonKey(fromJson: _favoritesSummaryFromJson)
  final FavoritesSummaryDto summary;

  Map<String, dynamic> toJson() => _$AddFavoriteResponseDtoToJson(this);
}

FavoritesItemDto _favoritesItemFromJson(Map<String, dynamic>? json) =>
    FavoritesItemDto.fromJson(json ?? const {});

FavoritesSummaryDto _favoritesSummaryFromJson(Map<String, dynamic>? json) =>
    FavoritesSummaryDto.fromJson(json ?? const {});
