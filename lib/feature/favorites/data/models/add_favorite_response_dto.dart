import 'package:zadana_user_v3/feature/favorites/data/models/favorites_item_dto.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/favorites_summary_dto.dart';

class AddFavoriteResponseDto {
  factory AddFavoriteResponseDto.fromJson(Map<String, dynamic> json) {
    return AddFavoriteResponseDto(
      message: json['message'] as String? ?? '',
      item: FavoritesItemDto.fromJson(
        json['item'] as Map<String, dynamic>? ?? const {},
      ),
      summary: FavoritesSummaryDto.fromJson(
        json['summary'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }
  const AddFavoriteResponseDto({
    required this.message,
    required this.item,
    required this.summary,
  });

  final String message;
  final FavoritesItemDto item;
  final FavoritesSummaryDto summary;
}
