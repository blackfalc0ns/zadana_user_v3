import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_item_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_price_summary_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_status.dart';

class OrderDetailsEntity {
  const OrderDetailsEntity({
    required this.id,
    required this.createdAt,
    required this.totalPrice,
    required this.status,
    required this.canCancel,
    required this.itemsCount,
    required this.summary,
    required this.items,
  });

  final String id;
  final DateTime createdAt;
  final double totalPrice;
  final OrderStatus status;
  final bool canCancel;
  final int itemsCount;
  final OrderPriceSummaryEntity summary;
  final List<OrderItemEntity> items;
}
