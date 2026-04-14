import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class ProductSearchEntity {
  const ProductSearchEntity({
    required this.query,
    required this.total,
    required this.page,
    required this.perPage,
    required this.items,
  });

  final String query;
  final int total;
  final int page;
  final int perPage;
  final List<ProductModel> items;
}
