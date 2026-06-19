import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class FavoritesResponseEntity {
  const FavoritesResponseEntity({
    required this.items,
    required this.itemsCount,
    required this.total,
    required this.page,
    required this.perPage,
  });

  final List<ProductModel> items;
  final int itemsCount;
  final int total;
  final int page;
  final int perPage;

  bool get hasMore => page * perPage < total;
}
