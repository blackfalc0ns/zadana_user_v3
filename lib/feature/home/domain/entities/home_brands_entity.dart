import 'package:zadana_user_v3/feature/brand/domain/entities/brand_model.dart';

class HomeBrandsEntity {
  final String key;
  final String title;
  final bool isActive;
  final String? theme;
  final int itemsCount;
  final List<BrandModel> items;

  const HomeBrandsEntity({
    required this.key,
    required this.title,
    required this.isActive,
    required this.theme,
    required this.itemsCount,
    required this.items,
  });
}
