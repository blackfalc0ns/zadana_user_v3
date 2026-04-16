import 'package:zadana_user_v3/feature/home/data/models/recommended/home_recommended_item_model_dto.dart';

class HomeRecommendedResponseModelDto {
  const HomeRecommendedResponseModelDto({
    this.key,
    this.title,
    this.isActive,
    this.theme,
    this.itemsCount,
    this.items,
  });

  factory HomeRecommendedResponseModelDto.fromJson(Map<String, dynamic> json) {
    return HomeRecommendedResponseModelDto(
      key: json['key'] as String?,
      title: json['title'] as String?,
      isActive: json['is_active'] as bool?,
      theme: json['theme'] as String?,
      itemsCount: json['items_count'] as int?,
      items: (json['items'] as List<dynamic>?)
          ?.map(
            (item) => HomeRecommendedItemModelDto.fromJson(
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
  final List<HomeRecommendedItemModelDto>? items;
}
