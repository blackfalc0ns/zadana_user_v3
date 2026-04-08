import 'package:zadana_user_v3/feature/home/data/models/home_featured_item_model_dto.dart';

class HomeFeaturedResponseModelDto {
  final String? key;
  final String? title;
  final bool? isActive;
  final String? theme;
  final int? itemsCount;
  final List<HomeFeaturedItemModelDto>? items;

  const HomeFeaturedResponseModelDto({
    this.key,
    this.title,
    this.isActive,
    this.theme,
    this.itemsCount,
    this.items,
  });

  factory HomeFeaturedResponseModelDto.fromJson(Map<String, dynamic> json) {
    return HomeFeaturedResponseModelDto(
      key: json['key'] as String?,
      title: json['title'] as String?,
      isActive: json['is_active'] as bool?,
      theme: json['theme'] as String?,
      itemsCount: json['items_count'] as int?,
      items: (json['items'] as List<dynamic>?)
          ?.map(
            (item) =>
                HomeFeaturedItemModelDto.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
