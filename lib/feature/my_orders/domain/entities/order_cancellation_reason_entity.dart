class OrderCancellationReasonEntity {
  const OrderCancellationReasonEntity({
    required this.code,
    required this.labelAr,
    required this.labelEn,
    required this.requiresNote,
  });

  final String code;
  final String labelAr;
  final String labelEn;
  final bool requiresNote;

  String labelForLanguageCode(String languageCode) {
    return languageCode.toLowerCase() == 'ar' ? labelAr : labelEn;
  }
}
