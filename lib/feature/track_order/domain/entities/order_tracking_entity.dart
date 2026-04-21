import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_status.dart';

class OrderTrackingEntity {
  const OrderTrackingEntity({
    required this.order,
    required this.estimatedDelivery,
    required this.driver,
    required this.timeline,
  });

  final OrderTrackingOrderEntity order;
  final OrderEstimatedDeliveryEntity? estimatedDelivery;
  final OrderTrackingDriverEntity? driver;
  final List<OrderTrackingTimelineItemEntity> timeline;
}

class OrderTrackingOrderEntity {
  const OrderTrackingOrderEntity({required this.id, required this.status});

  final String id;
  final OrderStatus status;
}

class OrderEstimatedDeliveryEntity {
  const OrderEstimatedDeliveryEntity({
    required this.dateTime,
    required this.formatted,
  });

  final DateTime? dateTime;
  final String formatted;
}

class OrderTrackingDriverEntity {
  const OrderTrackingDriverEntity({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.subtitle,
  });

  final String id;
  final String name;
  final String phoneNumber;
  final String subtitle;

  bool get hasPhoneNumber => phoneNumber.trim().isNotEmpty;
  bool get hasContent =>
      name.trim().isNotEmpty ||
      subtitle.trim().isNotEmpty ||
      phoneNumber.trim().isNotEmpty;
}

class OrderTrackingTimelineItemEntity {
  const OrderTrackingTimelineItemEntity({
    required this.id,
    required this.title,
    required this.time,
    required this.isActive,
    required this.isCompleted,
  });

  final String id;
  final String title;
  final String time;
  final bool isActive;
  final bool isCompleted;
}
