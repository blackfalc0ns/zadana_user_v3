import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class AddFavoriteResponseEntity {
  const AddFavoriteResponseEntity({
    required this.message,
    required this.item,
    required this.itemsCount,
  });

  final String message;
  final ProductModel item;
  final int itemsCount;
}
