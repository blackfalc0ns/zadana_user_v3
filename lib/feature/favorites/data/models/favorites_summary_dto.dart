class FavoritesSummaryDto {
  const FavoritesSummaryDto({required this.itemsCount});

  final int itemsCount;

  factory FavoritesSummaryDto.fromJson(Map<String, dynamic> json) {
    return FavoritesSummaryDto(
      itemsCount: (json['items_count'] as num?)?.toInt() ?? 0,
    );
  }
}
