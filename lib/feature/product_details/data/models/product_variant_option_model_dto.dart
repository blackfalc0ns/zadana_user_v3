import 'package:zadana_user_v3/feature/product_details/data/models/product_vendor_price_model_dto.dart';

class ProductVariantOptionModelDto {
  const ProductVariantOptionModelDto({
    this.id,
    this.defaultVendorProductId,
    this.nameAr,
    this.nameEn,
    this.displaySizeAr,
    this.displaySizeEn,
    this.isCurrent,
    this.imageUrl,
    this.images,
    this.packageTypeNameAr,
    this.packageTypeNameEn,
    this.measurementValue,
    this.measurementUnitNameAr,
    this.measurementUnitNameEn,
    this.unit,
    this.price,
    this.oldPrice,
    this.isDiscounted,
    this.vendorPrices,
    this.isOnlineNow,
    this.isAvailableForPurchase,
    this.unavailableReason,
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
      imageUrl: json['image_url'] as String?,
      images: (json['images'] as List<dynamic>?)?.cast<String>(),
      packageTypeNameAr: json['package_type_name_ar'] as String?,
      packageTypeNameEn: json['package_type_name_en'] as String?,
      measurementValue: (json['measurement_value'] as num?)?.toDouble(),
      measurementUnitNameAr: json['measurement_unit_name_ar'] as String?,
      measurementUnitNameEn: json['measurement_unit_name_en'] as String?,
      unit: json['unit'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      oldPrice: (json['old_price'] as num?)?.toDouble(),
      isDiscounted: json['is_discounted'] as bool?,
      vendorPrices: (json['vendor_prices'] as List<dynamic>?)
          ?.map(
            (item) => ProductVendorPriceModelDto.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      isOnlineNow: json['is_online_now'] as bool?,
      isAvailableForPurchase: json['is_available_for_purchase'] as bool?,
      unavailableReason: json['unavailable_reason'] as String?,
    );
  }

  final String? id;
  final String? defaultVendorProductId;
  final String? nameAr;
  final String? nameEn;
  final String? displaySizeAr;
  final String? displaySizeEn;
  final bool? isCurrent;
  final String? imageUrl;
  final List<String>? images;
  final String? packageTypeNameAr;
  final String? packageTypeNameEn;
  final double? measurementValue;
  final String? measurementUnitNameAr;
  final String? measurementUnitNameEn;
  final String? unit;
  final double? price;
  final double? oldPrice;
  final bool? isDiscounted;
  final List<ProductVendorPriceModelDto>? vendorPrices;
  final bool? isOnlineNow;
  final bool? isAvailableForPurchase;
  final String? unavailableReason;
}
