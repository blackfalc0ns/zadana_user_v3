import 'package:zadana_user_v3/feature/home/data/models/home_best_selling_item_model_dto.dart';

class HomeBestSellingResponseModelDto {
  const HomeBestSellingResponseModelDto({
    this.key,
    this.title,
    this.isActive,
    this.theme,
    this.itemsCount,
    this.items,
  });

  factory HomeBestSellingResponseModelDto.fromJson(Map<String, dynamic> json) {
    return HomeBestSellingResponseModelDto(
      key: json['key'] as String?,
      title: json['title'] as String?,
      isActive: json['is_active'] as bool?,
      theme: json['theme'] as String?,
      itemsCount: json['items_count'] as int?,
      items: (json['items'] as List<dynamic>?)
          ?.map(
            (item) => HomeBestSellingItemModelDto.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
  final String? key;
  final String? title;
  final bool? isActive;
  final String? theme;
  final int? itemsCount;
  final List<HomeBestSellingItemModelDto>? items;
}
