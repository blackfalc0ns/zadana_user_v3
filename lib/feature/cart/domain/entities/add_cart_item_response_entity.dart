import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_summary_entity.dart';

class AddCartItemResponseEntity {
  const AddCartItemResponseEntity({
    required this.message,
    required this.item,
    required this.summary,
  });

  final String message;
  final CartItemModel item;
  final CartSummaryEntity summary;
}
