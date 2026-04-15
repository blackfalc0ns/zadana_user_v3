import 'package:zadana_user_v3/core/network/network_constants.dart';
import 'package:zadana_user_v3/feature/brand/data/models/brand_products_item_model_dto.dart';
import 'package:zadana_user_v3/feature/brand/data/models/brand_products_response_model_dto.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_model.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_product_model.dart';

extension BrandProductsItemModelDtoMapper on BrandProductsItemModelDto {
  BrandProductModel toEntity(BrandModel brand) {
    return BrandProductModel(
      id: id ?? '',
      name: name ?? '',
      brandId: brand.id,
      brandName: brand.name,
      price: price ?? 0,
      oldPrice: oldPrice,
      imageUrl: _resolveImageUrl(imageUrl),
      emoji: brand.emoji,
      rating: rating,
      reviewCount: reviewCount,
      discount: discount,
      isFavorite: isFavorite ?? false,
      unit: unit,
    );
  }
}

extension BrandProductsResponseModelDtoMapper on BrandProductsResponseModelDto {
  List<BrandProductModel> toEntities(BrandModel brand) {
    return items?.map((item) => item.toEntity(brand)).toList() ?? const [];
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
