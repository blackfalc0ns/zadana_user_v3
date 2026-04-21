import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_status.dart';

class CancelOrderResponseEntity {
  const CancelOrderResponseEntity({required this.message, required this.order});

  final String message;
  final CancelledOrderEntity order;
}

class CancelledOrderEntity {
  const CancelledOrderEntity({required this.id, required this.status});

  final String id;
  final OrderStatus status;
}
