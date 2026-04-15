import 'package:zadana_user_v3/feature/home/domain/entities/home_category_item_entity.dart';

class HomeCategoriesEntity {
  const HomeCategoriesEntity({
    required this.key,
    required this.title,
    required this.isActive,
    required this.theme,
    required this.itemsCount,
    required this.items,
  });
  final String key;
  final String title;
  final bool isActive;
  final String? theme;
  final int itemsCount;
  final List<HomeCategoryItemEntity> items;
}
