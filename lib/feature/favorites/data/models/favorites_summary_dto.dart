class FavoritesSummaryDto {
  factory FavoritesSummaryDto.fromJson(Map<String, dynamic> json) {
    return FavoritesSummaryDto(
      itemsCount: (json['items_count'] as num?)?.toInt() ?? 0,
    );
  }
  const FavoritesSummaryDto({required this.itemsCount});

  final int itemsCount;
}
