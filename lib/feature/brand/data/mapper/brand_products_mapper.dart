import 'package:zadana_user_v3/core/network/network_constants.dart';
import 'package:zadana_user_v3/feature/brand/data/models/brand_products_applied_filters_dto.dart';
import 'package:zadana_user_v3/feature/brand/data/models/brand_products_item_model_dto.dart';
import 'package:zadana_user_v3/feature/brand/data/models/brand_products_response_model_dto.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_applied_filters_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_model.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_product_model.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_products_entity.dart';

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

  BrandProductsEntity toEntity(BrandModel brand) {
    return BrandProductsEntity(
      appliedFilters: appliedFilters?.toEntity(),
      total: total ?? 0,
      page: page ?? 1,
      perPage: perPage ?? 0,
      items: toEntities(brand),
    );
  }
}

extension BrandProductsAppliedFiltersDtoMapper on BrandProductsAppliedFiltersDto {
  BrandAppliedFiltersEntity toEntity() {
    return BrandAppliedFiltersEntity(
      categoryId: categoryId,
      subcategoryId: subcategoryId,
      unitId: unitId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      sort: sort,
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
