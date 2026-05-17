import 'package:zadana_user_v3/core/network/network_constants.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/product_details/data/models/product_details_response_model_dto.dart';
import 'package:zadana_user_v3/feature/product_details/data/models/product_variant_option_model_dto.dart';
import 'package:zadana_user_v3/feature/product_details/data/models/product_vendor_price_model_dto.dart';
import 'package:zadana_user_v3/feature/product_details/data/models/similar_product_model_dto.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_details_entity.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_variant_option_entity.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_vendor_price_entity.dart';

extension ProductVariantOptionModelDtoMapper on ProductVariantOptionModelDto {
  ProductVariantOptionEntity toEntity() {
    final resolvedImageUrl = _resolveImageUrl(imageUrl);
    final galleryImages = (images ?? const <String>[])
        .map(_resolveImageUrl)
        .where((item) => item.isNotEmpty)
        .toList();

    return ProductVariantOptionEntity(
      id: id ?? '',
      defaultVendorProductId: defaultVendorProductId ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      displaySizeAr: displaySizeAr ?? '',
      displaySizeEn: displaySizeEn ?? '',
      isCurrent: isCurrent ?? false,
      imageUrl: resolvedImageUrl.isNotEmpty ? resolvedImageUrl : null,
      images: galleryImages,
      packageTypeNameAr: packageTypeNameAr,
      packageTypeNameEn: packageTypeNameEn,
      measurementValue: measurementValue,
      measurementUnitNameAr: measurementUnitNameAr,
      measurementUnitNameEn: measurementUnitNameEn,
      unit: unit,
      price: price,
      oldPrice: oldPrice,
      isDiscounted: isDiscounted ?? false,
      vendorPrices:
          vendorPrices?.map((item) => item.toEntity()).toList() ?? const [],
    );
  }
}

extension ProductVendorPriceModelDtoMapper on ProductVendorPriceModelDto {
  ProductVendorPriceEntity toEntity() {
    return ProductVendorPriceEntity(
      id: id ?? '',
      name: name ?? '',
      logoUrl: _resolveImageUrl(logoUrl),
      price: price ?? 0,
      oldPrice: oldPrice,
      isDiscounted: isDiscounted ?? false,
    );
  }
}

extension SimilarProductModelDtoMapper on SimilarProductModelDto {
  ProductModel toEntity() {
    return ProductModel(
      id: id ?? '',
      name: name ?? '',
      store: store ?? '',
      price: price ?? 0,
      oldPrice: oldPrice,
      imageUrl: _resolveImageUrl(imageUrl),
      rating: rating,
      reviewCount: reviewCount,
      discount: discount,
      isFavorite: isFavorite ?? false,
      unit: unit,
      isDiscounted: isDiscounted ?? false,
    );
  }
}

extension ProductDetailsResponseModelDtoMapper
    on ProductDetailsResponseModelDto {
  ProductDetailsEntity toEntity() {
    final resolvedImageUrl = _resolveImageUrl(imageUrl);
    final galleryImages = (images ?? const <String>[])
        .map(_resolveImageUrl)
        .where((item) => item.isNotEmpty)
        .toList();

    return ProductDetailsEntity(
      id: id ?? '',
      masterProductId: masterProductId ?? '',
      defaultVendorProductId: defaultVendorProductId ?? '',
      name: name ?? '',
      store: store ?? '',
      price: price ?? 0,
      oldPrice: oldPrice,
      imageUrl: resolvedImageUrl,
      images: galleryImages.isNotEmpty
          ? galleryImages
          : (resolvedImageUrl.isNotEmpty
                ? <String>[resolvedImageUrl]
                : const []),
      rating: rating,
      reviewCount: reviewCount,
      discount: discount,
      isFavorite: isFavorite ?? false,
      unit: unit,
      isDiscounted: isDiscounted ?? false,
      description: description ?? '',
      variantOptions:
          variantOptions?.map((item) => item.toEntity()).toList() ?? const [],
      vendorPrices:
          vendorPrices?.map((item) => item.toEntity()).toList() ?? const [],
      similarProducts:
          similarProducts?.map((item) => item.toEntity()).toList() ?? const [],
      isOnlineNow: isOnlineNow ?? true,
      isAvailableForPurchase: isAvailableForPurchase ?? true,
      unavailableReason: unavailableReason,
    );
  }
}

String _resolveImageUrl(String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return '';
  }

  final uri = Uri.tryParse(imageUrl);
  if (uri != null && uri.hasScheme) {
    return imageUrl;
  }

  return Uri.parse(NetworkConstants.baseUrl).resolve(imageUrl).toString();
}
