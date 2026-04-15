import 'package:zadana_user_v3/feature/home/domain/entities/home_banner_item_entity.dart';

class HomeBannerEntity {
  const HomeBannerEntity({
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
  final List<HomeBannerItemEntity> items;
}
