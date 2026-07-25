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
    this.fulfillmentType,
    this.pickupOtpCode,
    this.pickupOtpExpiresAtUtc,
    this.pickupNoShowDeadlineUtc,
    this.pickupBranch,
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
      fulfillmentType: json['fulfillmentType']?.toString(),
      pickupOtpCode: json['pickupOtpCode']?.toString(),
      pickupOtpExpiresAtUtc: DateTime.tryParse(
        json['pickupOtpExpiresAtUtc']?.toString() ?? '',
      ),
      pickupNoShowDeadlineUtc: DateTime.tryParse(
        json['pickupNoShowDeadlineUtc']?.toString() ?? '',
      ),
      pickupBranch: _mapOrNull(json['pickupBranch']) == null
          ? null
          : OrderStatusChangedPickupBranchPayload.fromJson(
              _map(json['pickupBranch']),
            ),
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
  final String? fulfillmentType;
  final String? pickupOtpCode;
  final DateTime? pickupOtpExpiresAtUtc;
  final DateTime? pickupNoShowDeadlineUtc;
  final OrderStatusChangedPickupBranchPayload? pickupBranch;

  bool get isPickup =>
      fulfillmentType?.trim().toLowerCase() == 'pickup' ||
      pickupBranch != null ||
      (pickupOtpCode?.trim().isNotEmpty ?? false);

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
}

class OrderStatusChangedPickupBranchPayload {
  const OrderStatusChangedPickupBranchPayload({
    required this.name,
    required this.address,
    this.hoursToday,
  });

  factory OrderStatusChangedPickupBranchPayload.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderStatusChangedPickupBranchPayload(
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      hoursToday:
          json['hoursToday']?.toString() ?? json['hours_today']?.toString(),
    );
  }

  final String name;
  final String address;
  final String? hoursToday;
}
