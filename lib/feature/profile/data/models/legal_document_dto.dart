class LegalDocumentDto {
  const LegalDocumentDto({
    required this.documentType,
    required this.contentAr,
    required this.contentEn,
    required this.version,
    this.effectiveAtUtc,
    this.updatedAtUtc,
  });

  factory LegalDocumentDto.fromJson(Map<String, dynamic> json) =>
      LegalDocumentDto(
        documentType: json['documentType'] as String? ?? '',
        contentAr: json['contentAr'] as String? ?? '',
        contentEn: json['contentEn'] as String? ?? '',
        version: json['version'] as String? ?? '1.0',
        effectiveAtUtc: json['effectiveAtUtc'] == null
            ? null
            : DateTime.tryParse(json['effectiveAtUtc'] as String),
        updatedAtUtc: json['updatedAtUtc'] == null
            ? null
            : DateTime.tryParse(json['updatedAtUtc'] as String),
      );

  final String documentType;
  final String contentAr;
  final String contentEn;
  final String version;
  final DateTime? effectiveAtUtc;
  final DateTime? updatedAtUtc;
}
