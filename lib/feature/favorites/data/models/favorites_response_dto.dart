import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/favorites_item_dto.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/favorites_summary_dto.dart';

part 'favorites_response_dto.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class FavoritesResponseDto {
  const FavoritesResponseDto({
    required this.items,
    required this.summary,
    this.total,
    this.limit,
    this.offset,
    this.hasMore,
  });

  factory FavoritesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FavoritesResponseDtoFromJson(json);

  @JsonKey(fromJson: _favoritesItemsFromJson)
  final List<FavoritesItemDto> items;

  @JsonKey(fromJson: _favoritesSummaryFromJson)
  final FavoritesSummaryDto summary;

  final int? total;
  final int? limit;
  final int? offset;
  final bool? hasMore;

  Map<String, dynamic> toJson() => _$FavoritesResponseDtoToJson(this);
}

List<FavoritesItemDto> _favoritesItemsFromJson(List<dynamic>? json) =>
    (json ?? const [])
        .map((item) => FavoritesItemDto.fromJson(item as Map<String, dynamic>))
        .toList();

FavoritesSummaryDto _favoritesSummaryFromJson(Map<String, dynamic>? json) =>
    FavoritesSummaryDto.fromJson(json ?? const {});
