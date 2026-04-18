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
        return OrderStatus.pending;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
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
