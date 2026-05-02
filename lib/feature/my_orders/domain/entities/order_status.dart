enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  returning,
  cancelled,
  vendorRejected,
  deliveryFailed,
  unknown;

  bool get isActive =>
      this == OrderStatus.pending ||
      this == OrderStatus.processing ||
      this == OrderStatus.shipped;

  bool get isCompleted =>
      this == OrderStatus.delivered ||
      this == OrderStatus.cancelled ||
      this == OrderStatus.vendorRejected ||
      this == OrderStatus.deliveryFailed;

  bool get isReturning => this == OrderStatus.returning;

  bool get isCancelled => this == OrderStatus.cancelled;

  bool get isNegativeTerminal =>
      this == OrderStatus.cancelled ||
      this == OrderStatus.vendorRejected ||
      this == OrderStatus.deliveryFailed;

  bool get canCancel =>
      this == OrderStatus.pending || this == OrderStatus.processing;

  bool get canCreateComplaint =>
      this == OrderStatus.processing ||
      this == OrderStatus.shipped ||
      this == OrderStatus.delivered ||
      this == OrderStatus.returning;

  bool get canCreateReturnRequest => this == OrderStatus.delivered;

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
      case 'vendorrejected':
      case 'vendor_rejected':
      case 'rejected':
        return OrderStatus.vendorRejected;
      case 'deliveryfailed':
      case 'delivery_failed':
      case 'failed_delivery':
        return OrderStatus.deliveryFailed;
      default:
        return OrderStatus.unknown;
    }
  }
}
