class OrderStatusChangedRealtimePayload {
  const OrderStatusChangedRealtimePayload({
    required this.orderId,
    required this.newStatus,
    this.orderNumber,
    this.vendorId,
    this.oldStatus,
    this.actorRole,
    this.action,
    this.targetUrl,
    this.changedAtUtc,
  });

  factory OrderStatusChangedRealtimePayload.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderStatusChangedRealtimePayload(
      orderId: json['orderId']?.toString() ?? '',
      orderNumber: json['orderNumber']?.toString(),
      vendorId: json['vendorId']?.toString(),
      oldStatus: json['oldStatus']?.toString(),
      newStatus: json['newStatus']?.toString() ?? '',
      actorRole: json['actorRole']?.toString(),
      action: json['action']?.toString(),
      targetUrl: json['targetUrl']?.toString(),
      changedAtUtc: DateTime.tryParse(json['changedAtUtc']?.toString() ?? ''),
    );
  }

  final String orderId;
  final String? orderNumber;
  final String? vendorId;
  final String? oldStatus;
  final String newStatus;
  final String? actorRole;
  final String? action;
  final String? targetUrl;
  final DateTime? changedAtUtc;
}
