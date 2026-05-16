class BrandProductModel {
  const BrandProductModel({
    required this.id,
    required this.name,
    required this.brandId,
    required this.brandName,
    required this.price,
    this.oldPrice,
    required this.imageUrl,
    this.emoji,
    this.rating,
    this.reviewCount,
    this.discount,
    this.isFavorite = false,
    this.isInStock = true,
    this.unit,
    this.category,
    this.subcategory,
    this.size,
    this.isBestSeller = false,
    this.createdAt,
    this.packageTypeNameAr,
    this.packageTypeNameEn,
    this.measurementUnitNameAr,
    this.measurementUnitNameEn,
    this.measurementValue,
    this.displaySizeAr,
    this.displaySizeEn,
  });
  final String id;
  final String name;
  final String brandId;
  final String brandName;
  final double price;
  final double? oldPrice;
  final String imageUrl;
  final String? emoji;
  final double? rating;
  final int? reviewCount;
  final String? discount;
  final bool isFavorite;
  final bool isInStock;
  final String? unit;
  final String? category;
  final String? subcategory;
  final String? size;
  final bool isBestSeller;
  final DateTime? createdAt;
  final String? packageTypeNameAr;
  final String? packageTypeNameEn;
  final String? measurementUnitNameAr;
  final String? measurementUnitNameEn;
  final double? measurementValue;
  final String? displaySizeAr;
  final String? displaySizeEn;

  bool get hasDiscount => discount != null && discount!.isNotEmpty;

  BrandProductModel copyWith({
    String? id,
    String? name,
    String? brandId,
    String? brandName,
    double? price,
    double? oldPrice,
    String? imageUrl,
    String? emoji,
    double? rating,
    int? reviewCount,
    String? discount,
    bool? isFavorite,
    bool? isInStock,
    String? unit,
    String? category,
    String? subcategory,
    String? size,
    bool? isBestSeller,
    DateTime? createdAt,
    String? packageTypeNameAr,
    String? packageTypeNameEn,
    String? measurementUnitNameAr,
    String? measurementUnitNameEn,
    double? measurementValue,
    String? displaySizeAr,
    String? displaySizeEn,
  }) {
    return BrandProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      brandId: brandId ?? this.brandId,
      brandName: brandName ?? this.brandName,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      emoji: emoji ?? this.emoji,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      discount: discount ?? this.discount,
      isFavorite: isFavorite ?? this.isFavorite,
      isInStock: isInStock ?? this.isInStock,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      size: size ?? this.size,
      isBestSeller: isBestSeller ?? this.isBestSeller,
      createdAt: createdAt ?? this.createdAt,
      packageTypeNameAr: packageTypeNameAr ?? this.packageTypeNameAr,
      packageTypeNameEn: packageTypeNameEn ?? this.packageTypeNameEn,
      measurementUnitNameAr:
          measurementUnitNameAr ?? this.measurementUnitNameAr,
      measurementUnitNameEn:
          measurementUnitNameEn ?? this.measurementUnitNameEn,
      measurementValue: measurementValue ?? this.measurementValue,
      displaySizeAr: displaySizeAr ?? this.displaySizeAr,
      displaySizeEn: displaySizeEn ?? this.displaySizeEn,
    );
  }
}
