import 'package:zadana_user_v3/feature/favorites/data/models/favorites_summary_dto.dart';

class RemoveFavoriteResponseDto {
  factory RemoveFavoriteResponseDto.fromJson(Map<String, dynamic> json) {
    return RemoveFavoriteResponseDto(
      message: json['message'] as String? ?? '',
      summary: FavoritesSummaryDto.fromJson(
        json['summary'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }
  const RemoveFavoriteResponseDto({
    required this.message,
    required this.summary,
  });

  final String message;
  final FavoritesSummaryDto summary;
}
