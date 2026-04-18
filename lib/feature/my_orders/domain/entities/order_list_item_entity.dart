import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_item_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_status.dart';

class OrderListItemEntity {
  const OrderListItemEntity({
    required this.id,
    required this.createdAt,
    required this.totalPrice,
    required this.status,
    required this.itemsCount,
    required this.items,
  });

  final String id;
  final DateTime createdAt;
  final double totalPrice;
  final OrderStatus status;
  final int itemsCount;
  final List<OrderItemEntity> items;
}
