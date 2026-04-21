import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_status.dart';
import 'package:zadana_user_v3/feature/track_order/domain/entities/order_tracking_entity.dart';

class OrderTrackingResponseDto {
  const OrderTrackingResponseDto({
    required this.order,
    required this.estimatedDelivery,
    required this.driver,
    required this.timeline,
  });

  factory OrderTrackingResponseDto.fromJson(Map<String, dynamic> json) {
    return OrderTrackingResponseDto(
      order: OrderTrackingOrderDto.fromJson(_map(json['order'])),
      estimatedDelivery: _mapOrNull(json['estimated_delivery']) == null
          ? null
          : OrderEstimatedDeliveryDto.fromJson(
              _map(json['estimated_delivery']),
            ),
      driver: _mapOrNull(json['driver']) == null
          ? null
          : OrderTrackingDriverDto.fromJson(_map(json['driver'])),
      timeline: _list(json['timeline'])
          .map((item) => OrderTrackingTimelineItemDto.fromJson(_map(item)))
          .toList(growable: false),
    );
  }

  final OrderTrackingOrderDto order;
  final OrderEstimatedDeliveryDto? estimatedDelivery;
  final OrderTrackingDriverDto? driver;
  final List<OrderTrackingTimelineItemDto> timeline;

  OrderTrackingEntity toEntity() {
    return OrderTrackingEntity(
      order: order.toEntity(),
      estimatedDelivery: estimatedDelivery?.toEntity(),
      driver: driver?.toEntity(),
      timeline: timeline.map((item) => item.toEntity()).toList(growable: false),
    );
  }

  static Map<String, dynamic> _map(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }
    return const <String, dynamic>{};
  }

  static Map<String, dynamic>? _mapOrNull(dynamic value) {
    if (value == null) return null;
    final map = _map(value);
    return map.isEmpty ? null : map;
  }

  static List<dynamic> _list(dynamic value) {
    if (value is List) return value;
    return const <dynamic>[];
  }
}

class OrderTrackingOrderDto {
  const OrderTrackingOrderDto({required this.id, required this.status});

  factory OrderTrackingOrderDto.fromJson(Map<String, dynamic> json) {
    return OrderTrackingOrderDto(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }

  final String id;
  final String status;

  OrderTrackingOrderEntity toEntity() {
    return OrderTrackingOrderEntity(
      id: id,
      status: OrderStatus.fromApi(status),
    );
  }
}

class OrderEstimatedDeliveryDto {
  const OrderEstimatedDeliveryDto({
    required this.dateTime,
    required this.formatted,
  });

  factory OrderEstimatedDeliveryDto.fromJson(Map<String, dynamic> json) {
    return OrderEstimatedDeliveryDto(
      dateTime: DateTime.tryParse(json['datetime']?.toString() ?? ''),
      formatted: json['formatted']?.toString() ?? '',
    );
  }

  final DateTime? dateTime;
  final String formatted;

  OrderEstimatedDeliveryEntity toEntity() {
    return OrderEstimatedDeliveryEntity(
      dateTime: dateTime,
      formatted: formatted,
    );
  }
}

class OrderTrackingDriverDto {
  const OrderTrackingDriverDto({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.subtitle,
  });

  factory OrderTrackingDriverDto.fromJson(Map<String, dynamic> json) {
    return OrderTrackingDriverDto(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
    );
  }

  final String id;
  final String name;
  final String phoneNumber;
  final String subtitle;

  OrderTrackingDriverEntity toEntity() {
    return OrderTrackingDriverEntity(
      id: id,
      name: name,
      phoneNumber: phoneNumber,
      subtitle: subtitle,
    );
  }
}

class OrderTrackingTimelineItemDto {
  const OrderTrackingTimelineItemDto({
    required this.id,
    required this.title,
    required this.time,
    required this.isActive,
    required this.isCompleted,
  });

  factory OrderTrackingTimelineItemDto.fromJson(Map<String, dynamic> json) {
    return OrderTrackingTimelineItemDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      isActive: json['is_active'] as bool? ?? false,
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }

  final String id;
  final String title;
  final String time;
  final bool isActive;
  final bool isCompleted;

  OrderTrackingTimelineItemEntity toEntity() {
    return OrderTrackingTimelineItemEntity(
      id: id,
      title: title,
      time: time,
      isActive: isActive,
      isCompleted: isCompleted,
    );
  }
}
