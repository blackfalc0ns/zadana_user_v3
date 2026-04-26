import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_status.dart';

class OrderTrackingEntity {
  const OrderTrackingEntity({
    required this.order,
    required this.estimatedDelivery,
    required this.driver,
    required this.assignedDriver,
    required this.driverArrivalState,
    required this.driverArrivalUpdatedAtUtc,
    required this.deliveryOtp,
    required this.showDeliveryOtp,
    required this.timeline,
  });

  final OrderTrackingOrderEntity order;
  final OrderEstimatedDeliveryEntity? estimatedDelivery;
  final OrderTrackingDriverEntity? driver;
  final OrderTrackingAssignedDriverEntity? assignedDriver;
  final DriverArrivalState? driverArrivalState;
  final DateTime? driverArrivalUpdatedAtUtc;
  final String deliveryOtp;
  final bool showDeliveryOtp;
  final List<OrderTrackingTimelineItemEntity> timeline;

  OrderTrackingEntity copyWith({
    OrderTrackingOrderEntity? order,
    OrderEstimatedDeliveryEntity? estimatedDelivery,
    OrderTrackingDriverEntity? driver,
    OrderTrackingAssignedDriverEntity? assignedDriver,
    DriverArrivalState? driverArrivalState,
    DateTime? driverArrivalUpdatedAtUtc,
    String? deliveryOtp,
    bool? showDeliveryOtp,
    List<OrderTrackingTimelineItemEntity>? timeline,
  }) {
    return OrderTrackingEntity(
      order: order ?? this.order,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      driver: driver ?? this.driver,
      assignedDriver: assignedDriver ?? this.assignedDriver,
      driverArrivalState: driverArrivalState ?? this.driverArrivalState,
      driverArrivalUpdatedAtUtc:
          driverArrivalUpdatedAtUtc ?? this.driverArrivalUpdatedAtUtc,
      deliveryOtp: deliveryOtp ?? this.deliveryOtp,
      showDeliveryOtp: showDeliveryOtp ?? this.showDeliveryOtp,
      timeline: timeline ?? this.timeline,
    );
  }
}

class OrderTrackingOrderEntity {
  const OrderTrackingOrderEntity({required this.id, required this.status});

  final String id;
  final OrderStatus status;

  OrderTrackingOrderEntity copyWith({String? id, OrderStatus? status}) {
    return OrderTrackingOrderEntity(
      id: id ?? this.id,
      status: status ?? this.status,
    );
  }
}

class OrderEstimatedDeliveryEntity {
  const OrderEstimatedDeliveryEntity({
    required this.dateTime,
    required this.formatted,
  });

  final DateTime? dateTime;
  final String formatted;

  OrderEstimatedDeliveryEntity copyWith({
    DateTime? dateTime,
    String? formatted,
  }) {
    return OrderEstimatedDeliveryEntity(
      dateTime: dateTime ?? this.dateTime,
      formatted: formatted ?? this.formatted,
    );
  }
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

  OrderTrackingDriverEntity copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? subtitle,
  }) {
    return OrderTrackingDriverEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      subtitle: subtitle ?? this.subtitle,
    );
  }
}

class OrderTrackingAssignedDriverEntity {
  const OrderTrackingAssignedDriverEntity({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.vehicleType,
    required this.plateNumber,
  });

  final String id;
  final String name;
  final String phoneNumber;
  final String vehicleType;
  final String plateNumber;

  bool get hasPhoneNumber => phoneNumber.trim().isNotEmpty;
  bool get hasContent =>
      name.trim().isNotEmpty ||
      vehicleType.trim().isNotEmpty ||
      plateNumber.trim().isNotEmpty ||
      phoneNumber.trim().isNotEmpty;

  OrderTrackingAssignedDriverEntity copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? vehicleType,
    String? plateNumber,
  }) {
    return OrderTrackingAssignedDriverEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      plateNumber: plateNumber ?? this.plateNumber,
    );
  }
}

enum DriverArrivalState {
  enRoute,
  arrivedAtVendor,
  arrivedAtCustomer;

  static DriverArrivalState? fromApi(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'en_route':
        return DriverArrivalState.enRoute;
      case 'arrived_at_vendor':
        return DriverArrivalState.arrivedAtVendor;
      case 'arrived_at_customer':
        return DriverArrivalState.arrivedAtCustomer;
      default:
        return null;
    }
  }
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

  OrderTrackingTimelineItemEntity copyWith({
    String? id,
    String? title,
    String? time,
    bool? isActive,
    bool? isCompleted,
  }) {
    return OrderTrackingTimelineItemEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
