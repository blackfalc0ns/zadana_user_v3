import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class FavoritesResponseEntity {
  const FavoritesResponseEntity({
    required this.items,
    required this.itemsCount,
    required this.total,
    required this.limit,
    required this.offset,
    required this.hasMore,
  });

  final List<ProductModel> items;
  final int itemsCount;
  final int total;
  final int limit;
  final int offset;
  final bool hasMore;
}
