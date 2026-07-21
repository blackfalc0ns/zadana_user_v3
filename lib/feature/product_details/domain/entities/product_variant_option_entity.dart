import 'package:zadana_user_v3/feature/product_details/domain/entities/product_vendor_price_entity.dart';

class ProductVariantOptionEntity {
  const ProductVariantOptionEntity({
    required this.id,
    this.defaultVendorProductId,
    required this.nameAr,
    required this.nameEn,
    required this.displaySizeAr,
    required this.displaySizeEn,
    required this.isCurrent,
    this.imageUrl,
    this.images = const [],
    this.packageTypeNameAr,
    this.packageTypeNameEn,
    this.measurementValue,
    this.measurementUnitNameAr,
    this.measurementUnitNameEn,
    this.unit,
    this.price,
    this.oldPrice,
    this.isDiscounted = false,
    this.vendorPrices = const [],
    this.isOnlineNow = true,
    this.isAvailableForPurchase = true,
    this.unavailableReason,
  });

  final String id;
  final String? defaultVendorProductId;
  final String nameAr;
  final String nameEn;
  final String displaySizeAr;
  final String displaySizeEn;
  final bool isCurrent;
  final String? imageUrl;
  final List<String> images;
  final String? packageTypeNameAr;
  final String? packageTypeNameEn;
  final double? measurementValue;
  final String? measurementUnitNameAr;
  final String? measurementUnitNameEn;
  final String? unit;
  final double? price;
  final double? oldPrice;
  final bool isDiscounted;
  final List<ProductVendorPriceEntity> vendorPrices;
  final bool isOnlineNow;
  final bool isAvailableForPurchase;
  final String? unavailableReason;

  ProductVariantOptionEntity copyWith({bool? isCurrent}) {
    return ProductVariantOptionEntity(
      id: id,
      defaultVendorProductId: defaultVendorProductId,
      nameAr: nameAr,
      nameEn: nameEn,
      displaySizeAr: displaySizeAr,
      displaySizeEn: displaySizeEn,
      isCurrent: isCurrent ?? this.isCurrent,
      imageUrl: imageUrl,
      images: images,
      packageTypeNameAr: packageTypeNameAr,
      packageTypeNameEn: packageTypeNameEn,
      measurementValue: measurementValue,
      measurementUnitNameAr: measurementUnitNameAr,
      measurementUnitNameEn: measurementUnitNameEn,
      unit: unit,
      price: price,
      oldPrice: oldPrice,
      isDiscounted: isDiscounted,
      vendorPrices: vendorPrices,
      isOnlineNow: isOnlineNow,
      isAvailableForPurchase: isAvailableForPurchase,
      unavailableReason: unavailableReason,
    );
  }
}
