import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_item_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_price_summary_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_status.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_case_entity.dart';

class OrderDetailsEntity {
  const OrderDetailsEntity({
    required this.id,
    required this.createdAt,
    required this.totalPrice,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.canCancel,
    required this.canRetryPayment,
    required this.canDelete,
    required this.itemsCount,
    required this.summary,
    required this.items,
    required this.activeCase,
  });

  final String id;
  final DateTime createdAt;
  final double totalPrice;
  final OrderStatus status;
  final String paymentStatus;
  final String paymentMethod;
  final bool canCancel;
  final bool canRetryPayment;
  final bool canDelete;
  final int itemsCount;
  final OrderPriceSummaryEntity summary;
  final List<OrderItemEntity> items;
  final OrderSupportCaseSummaryEntity? activeCase;
}
