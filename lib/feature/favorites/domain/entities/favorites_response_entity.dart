import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class FavoritesResponseEntity {
  const FavoritesResponseEntity({
    required this.items,
    required this.itemsCount,
  });

  final List<ProductModel> items;
  final int itemsCount;
}
