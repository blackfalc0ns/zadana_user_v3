class OrderSupportCaseChangedRealtimePayload {
  const OrderSupportCaseChangedRealtimePayload({
    required this.caseId,
    required this.orderId,
    required this.orderNumber,
    required this.type,
    required this.status,
    required this.action,
    required this.targetUrl,
    required this.changedAtUtc,
  });

  factory OrderSupportCaseChangedRealtimePayload.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderSupportCaseChangedRealtimePayload(
      caseId: json['caseId']?.toString() ?? json['case_id']?.toString() ?? '',
      orderId:
          json['orderId']?.toString() ?? json['order_id']?.toString() ?? '',
      orderNumber: json['orderNumber']?.toString() ??
          json['order_number']?.toString(),
      type: json['type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      action: json['action']?.toString() ?? '',
      targetUrl: json['targetUrl']?.toString() ??
          json['target_url']?.toString(),
      changedAtUtc: DateTime.tryParse(
        json['changedAtUtc']?.toString() ??
            json['changed_at_utc']?.toString() ??
            '',
      ),
    );
  }

  final String caseId;
  final String orderId;
  final String? orderNumber;
  final String type;
  final String status;
  final String action;
  final String? targetUrl;
  final DateTime? changedAtUtc;
}
