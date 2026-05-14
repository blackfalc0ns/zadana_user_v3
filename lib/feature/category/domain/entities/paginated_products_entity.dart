import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class PaginatedProductsEntity {
  const PaginatedProductsEntity({
    required this.items,
    required this.total,
    required this.page,
    required this.perPage,
  });

  final List<ProductModel> items;
  final int total;
  final int page;
  final int perPage;

  bool get hasMore => items.length >= perPage && (page * perPage) < total;
}
