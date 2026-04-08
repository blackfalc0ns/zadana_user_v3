import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class HomeExploreMoreEntity {
  final String key;
  final String title;
  final bool isActive;
  final dynamic theme;
  final int itemsCount;
  final List<ProductModel> items;

  const HomeExploreMoreEntity({
    required this.key,
    required this.title,
    required this.isActive,
    required this.theme,
    required this.itemsCount,
    required this.items,
  });
}
