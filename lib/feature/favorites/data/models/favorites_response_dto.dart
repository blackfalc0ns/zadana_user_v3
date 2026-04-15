import 'package:zadana_user_v3/feature/favorites/data/models/favorites_item_dto.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/favorites_summary_dto.dart';

class FavoritesResponseDto {
  factory FavoritesResponseDto.fromJson(Map<String, dynamic> json) {
    return FavoritesResponseDto(
      items: (json['items'] as List<dynamic>? ?? const [])
          .map(
            (item) => FavoritesItemDto.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      summary: FavoritesSummaryDto.fromJson(
        json['summary'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }
  const FavoritesResponseDto({required this.items, required this.summary});

  final List<FavoritesItemDto> items;
  final FavoritesSummaryDto summary;
}
