class DriverArrivalStateChangedRealtimePayload {
  const DriverArrivalStateChangedRealtimePayload({
    required this.orderId,
    required this.arrivalState,
    this.orderNumber,
    this.driverName,
    this.actorRole,
    this.targetUrl,
    this.changedAtUtc,
  });

  factory DriverArrivalStateChangedRealtimePayload.fromJson(
    Map<String, dynamic> json,
  ) {
    return DriverArrivalStateChangedRealtimePayload(
      orderId: json['orderId']?.toString() ?? '',
      orderNumber: json['orderNumber']?.toString(),
      arrivalState: json['arrivalState']?.toString() ?? '',
      driverName: json['driverName']?.toString(),
      actorRole: json['actorRole']?.toString(),
      targetUrl: json['targetUrl']?.toString(),
      changedAtUtc: DateTime.tryParse(json['changedAtUtc']?.toString() ?? ''),
    );
  }

  final String orderId;
  final String? orderNumber;
  final String arrivalState;
  final String? driverName;
  final String? actorRole;
  final String? targetUrl;
  final DateTime? changedAtUtc;
}
