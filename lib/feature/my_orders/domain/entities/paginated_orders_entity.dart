import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_list_item_entity.dart';

class PaginatedOrdersEntity {
  const PaginatedOrdersEntity({
    required this.items,
    required this.page,
    required this.perPage,
    required this.total,
  });

  final List<OrderListItemEntity> items;
  final int page;
  final int perPage;
  final int total;

  bool get hasMore => page * perPage < total;
}
