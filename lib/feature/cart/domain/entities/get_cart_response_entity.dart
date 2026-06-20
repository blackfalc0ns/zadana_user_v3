import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_summary_entity.dart';

class GetCartResponseEntity {
  const GetCartResponseEntity({
    required this.items,
    required this.summary,
    required this.total,
    required this.limit,
    required this.offset,
    required this.hasMore,
  });

  final List<CartItemModel> items;
  final CartSummaryEntity summary;
  final int total;
  final int limit;
  final int offset;
  final bool hasMore;
}
