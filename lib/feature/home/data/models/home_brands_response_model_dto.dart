import 'package:zadana_user_v3/feature/home/data/models/home_brand_item_model_dto.dart';

class HomeBrandsResponseModelDto {
  final String? key;
  final String? title;
  final bool? isActive;
  final String? theme;
  final int? itemsCount;
  final List<HomeBrandItemModelDto>? items;

  const HomeBrandsResponseModelDto({
    this.key,
    this.title,
    this.isActive,
    this.theme,
    this.itemsCount,
    this.items,
  });

  factory HomeBrandsResponseModelDto.fromJson(Map<String, dynamic> json) {
    return HomeBrandsResponseModelDto(
      key: json['key'] as String?,
      title: json['title'] as String?,
      isActive: json['is_active'] as bool?,
      theme: json['theme'] as String?,
      itemsCount: json['items_count'] as int?,
      items: (json['items'] as List<dynamic>?)
          ?.map(
            (item) =>
                HomeBrandItemModelDto.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
