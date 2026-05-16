class ProductVariantOptionModelDto {
  const ProductVariantOptionModelDto({
    this.id,
    this.defaultVendorProductId,
    this.nameAr,
    this.nameEn,
    this.displaySizeAr,
    this.displaySizeEn,
    this.isCurrent,
  });

  factory ProductVariantOptionModelDto.fromJson(Map<String, dynamic> json) {
    return ProductVariantOptionModelDto(
      id: json['id'] as String?,
      defaultVendorProductId: json['default_vendor_product_id'] as String?,
      nameAr: json['name_ar'] as String?,
      nameEn: json['name_en'] as String?,
      displaySizeAr: json['display_size_ar'] as String?,
      displaySizeEn: json['display_size_en'] as String?,
      isCurrent: json['is_current'] as bool?,
    );
  }

  final String? id;
  final String? defaultVendorProductId;
  final String? nameAr;
  final String? nameEn;
  final String? displaySizeAr;
  final String? displaySizeEn;
  final bool? isCurrent;
}
