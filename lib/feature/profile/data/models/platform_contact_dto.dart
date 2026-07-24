class PlatformContactDto {
  const PlatformContactDto({
    this.supportEmail,
    this.supportPhone,
    this.whatsAppUrl,
    this.instagramUrl,
    this.twitterUrl,
    this.tikTokUrl,
    this.snapchatUrl,
    this.facebookUrl,
    this.youTubeUrl,
    this.linkedInUrl,
    this.updatedAtUtc,
  });

  factory PlatformContactDto.fromJson(Map<String, dynamic> json) =>
      PlatformContactDto(
        supportEmail: json['supportEmail'] as String?,
        supportPhone: json['supportPhone'] as String?,
        whatsAppUrl: json['whatsAppUrl'] as String?,
        instagramUrl: json['instagramUrl'] as String?,
        twitterUrl: json['twitterUrl'] as String?,
        tikTokUrl: json['tikTokUrl'] as String?,
        snapchatUrl: json['snapchatUrl'] as String?,
        facebookUrl: json['facebookUrl'] as String?,
        youTubeUrl: json['youTubeUrl'] as String?,
        linkedInUrl: json['linkedInUrl'] as String?,
        updatedAtUtc: json['updatedAtUtc'] == null
            ? null
            : DateTime.tryParse(json['updatedAtUtc'] as String),
      );

  final String? supportEmail;
  final String? supportPhone;
  final String? whatsAppUrl;
  final String? instagramUrl;
  final String? twitterUrl;
  final String? tikTokUrl;
  final String? snapchatUrl;
  final String? facebookUrl;
  final String? youTubeUrl;
  final String? linkedInUrl;
  final DateTime? updatedAtUtc;
}
