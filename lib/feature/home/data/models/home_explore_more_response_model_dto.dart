import 'package:zadana_user_v3/feature/home/data/models/home_explore_more_item_model_dto.dart';

class HomeExploreMoreResponseModelDto {
  final String? key;
  final String? title;
  final bool? isActive;
  final dynamic theme;
  final int? itemsCount;
  final List<HomeExploreMoreItemModelDto>? items;

  const HomeExploreMoreResponseModelDto({
    this.key,
    this.title,
    this.isActive,
    this.theme,
    this.itemsCount,
    this.items,
  });

  factory HomeExploreMoreResponseModelDto.fromJson(Map<String, dynamic> json) {
    return HomeExploreMoreResponseModelDto(
      key: json['key'] as String?,
      title: json['title'] as String?,
      isActive: json['is_active'] as bool?,
      theme: json['theme'],
      itemsCount: json['items_count'] as int?,
      items: (json['items'] as List<dynamic>?)
          ?.map(
            (item) => HomeExploreMoreItemModelDto.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}
