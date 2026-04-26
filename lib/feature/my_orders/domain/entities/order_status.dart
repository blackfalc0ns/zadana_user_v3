enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  returning,
  cancelled,
  unknown;

  bool get isActive =>
      this == OrderStatus.pending ||
      this == OrderStatus.processing ||
      this == OrderStatus.shipped;

  bool get isCompleted => this == OrderStatus.delivered;

  bool get isReturning => this == OrderStatus.returning;

  bool get isCancelled => this == OrderStatus.cancelled;

  bool get canCancel =>
      this == OrderStatus.pending || this == OrderStatus.processing;

  static OrderStatus fromApi(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'pending':
      case 'pendingvendoracceptance':
      case 'order_placed':
        return OrderStatus.pending;
      case 'processing':
      case 'accepted':
      case 'vendor_confirmed':
      case 'preparing':
      case 'ready_for_pickup':
      case 'readyforpickup':
        return OrderStatus.processing;
      case 'shipped':
      case 'out_for_delivery':
      case 'outfordelivery':
      case 'driver_assigned':
      case 'driverassigned':
      case 'on_the_way':
      case 'ontheway':
        return OrderStatus.shipped;
      case 'delivered':
      case 'completed':
        return OrderStatus.delivered;
      case 'returning':
      case 'returned':
      case 'return':
        return OrderStatus.returning;
      case 'cancelled':
      case 'canceled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.unknown;
    }
  }
}
