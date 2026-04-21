class CancelOrderRequestEntity {
  const CancelOrderRequestEntity({
    required this.reasonCode,
    required this.reason,
    required this.note,
  });

  final String reasonCode;
  final String reason;
  final String note;
}
