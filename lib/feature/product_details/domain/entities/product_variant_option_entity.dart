class ProductVariantOptionEntity {
  const ProductVariantOptionEntity({
    required this.id,
    required this.defaultVendorProductId,
    required this.nameAr,
    required this.nameEn,
    required this.displaySizeAr,
    required this.displaySizeEn,
    required this.isCurrent,
  });

  final String id;
  final String defaultVendorProductId;
  final String nameAr;
  final String nameEn;
  final String displaySizeAr;
  final String displaySizeEn;
  final bool isCurrent;
}
