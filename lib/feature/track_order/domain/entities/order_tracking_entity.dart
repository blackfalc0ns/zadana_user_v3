import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_status.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_case_entity.dart';

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
    required this.fulfillmentType,
    required this.pickupOtpCode,
    required this.pickupOtpExpiresAtUtc,
    required this.pickupNoShowDeadlineUtc,
    required this.pickupBranch,
    required this.timeline,
    required this.activeCase,
  });

  final OrderTrackingOrderEntity order;
  final OrderEstimatedDeliveryEntity? estimatedDelivery;
  final OrderTrackingDriverEntity? driver;
  final OrderTrackingAssignedDriverEntity? assignedDriver;
  final DriverArrivalState? driverArrivalState;
  final DateTime? driverArrivalUpdatedAtUtc;
  final String deliveryOtp;
  final bool showDeliveryOtp;
  final String fulfillmentType;
  final String pickupOtpCode;
  final DateTime? pickupOtpExpiresAtUtc;
  final DateTime? pickupNoShowDeadlineUtc;
  final OrderPickupBranchEntity? pickupBranch;
  final List<OrderTrackingTimelineItemEntity> timeline;
  final OrderSupportCaseSummaryEntity? activeCase;

  bool get isPickup => fulfillmentType.trim().toLowerCase() == 'pickup';
  bool get shouldShowPickupOtp => isPickup && pickupOtpCode.trim().isNotEmpty;

  OrderTrackingEntity copyWith({
    OrderTrackingOrderEntity? order,
    OrderEstimatedDeliveryEntity? estimatedDelivery,
    OrderTrackingDriverEntity? driver,
    OrderTrackingAssignedDriverEntity? assignedDriver,
    DriverArrivalState? driverArrivalState,
    DateTime? driverArrivalUpdatedAtUtc,
    String? deliveryOtp,
    bool? showDeliveryOtp,
    String? fulfillmentType,
    String? pickupOtpCode,
    DateTime? pickupOtpExpiresAtUtc,
    DateTime? pickupNoShowDeadlineUtc,
    OrderPickupBranchEntity? pickupBranch,
    List<OrderTrackingTimelineItemEntity>? timeline,
    OrderSupportCaseSummaryEntity? activeCase,
    bool clearPickupOtp = false,
    bool clearPickupOtpExpiresAtUtc = false,
    bool clearPickupNoShowDeadlineUtc = false,
    bool clearPickupBranch = false,
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
      fulfillmentType: fulfillmentType ?? this.fulfillmentType,
      pickupOtpCode: clearPickupOtp ? '' : pickupOtpCode ?? this.pickupOtpCode,
      pickupOtpExpiresAtUtc: clearPickupOtpExpiresAtUtc
          ? null
          : pickupOtpExpiresAtUtc ?? this.pickupOtpExpiresAtUtc,
      pickupNoShowDeadlineUtc: clearPickupNoShowDeadlineUtc
          ? null
          : pickupNoShowDeadlineUtc ?? this.pickupNoShowDeadlineUtc,
      pickupBranch: clearPickupBranch
          ? null
          : pickupBranch ?? this.pickupBranch,
      timeline: timeline ?? this.timeline,
      activeCase: activeCase ?? this.activeCase,
    );
  }
}

class OrderPickupBranchEntity {
  const OrderPickupBranchEntity({
    required this.name,
    required this.address,
    this.addressLine,
    this.city,
    this.hoursToday,
  });

  final String name;
  final String address;
  final String? addressLine;
  final String? city;
  final String? hoursToday;

  String get displayAddress {
    final fullAddress = address.trim();
    if (fullAddress.isNotEmpty) return fullAddress;
    return [addressLine, city]
        .whereType<String>()
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .join(', ');
  }
}

class OrderTrackingOrderEntity {
  const OrderTrackingOrderEntity({
    required this.id,
    required this.orderNumber,
    required this.status,
  });

  final String id;
  final String orderNumber;
  final OrderStatus status;

  String get displayNumber {
    final normalized = orderNumber.trim();
    if (normalized.isNotEmpty) return normalized;
    return id;
  }

  OrderTrackingOrderEntity copyWith({
    String? id,
    String? orderNumber,
    OrderStatus? status,
  }) {
    return OrderTrackingOrderEntity(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      status: status ?? this.status,
    );
  }
}

class OrderEstimatedDeliveryEntity {
  const OrderEstimatedDeliveryEntity({
    required this.dateTime,
    required this.formatted,
    this.minMinutes,
    this.maxMinutes,
    this.label,
    this.confidence,
    this.source,
    this.isApproximate,
    this.calculationMode,
    this.explanation,
  });

  final DateTime? dateTime;
  final String formatted;
  final int? minMinutes;
  final int? maxMinutes;
  final String? label;
  final String? confidence;
  final String? source;
  final bool? isApproximate;
  final String? calculationMode;
  final String? explanation;

  /// Returns the best display label for the ETA.
  /// Prefers the window-based [label] if available, falls back to [formatted].
  String get displayLabel {
    final windowLabel = label?.trim() ?? '';
    if (windowLabel.isNotEmpty) return windowLabel;
    return formatted;
  }

  /// Whether this ETA uses the new window-based format.
  bool get hasDeliveryWindow => minMinutes != null && maxMinutes != null;

  OrderEstimatedDeliveryEntity copyWith({
    DateTime? dateTime,
    String? formatted,
    int? minMinutes,
    int? maxMinutes,
    String? label,
    String? confidence,
    String? source,
    bool? isApproximate,
    String? calculationMode,
    String? explanation,
  }) {
    return OrderEstimatedDeliveryEntity(
      dateTime: dateTime ?? this.dateTime,
      formatted: formatted ?? this.formatted,
      minMinutes: minMinutes ?? this.minMinutes,
      maxMinutes: maxMinutes ?? this.maxMinutes,
      label: label ?? this.label,
      confidence: confidence ?? this.confidence,
      source: source ?? this.source,
      isApproximate: isApproximate ?? this.isApproximate,
      calculationMode: calculationMode ?? this.calculationMode,
      explanation: explanation ?? this.explanation,
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
