import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/search/data/models/product_search_item_dto.dart';
import 'package:zadana_user_v3/feature/search/data/models/product_search_response_dto.dart';
import 'package:zadana_user_v3/feature/search/domain/entities/product_search_entity.dart';

extension ProductSearchItemDtoMapper on ProductSearchItemDto {
  ProductModel toEntity() {
    return ProductModel(
      id: id ?? '',
      name: name ?? '',
      store: store ?? '',
      price: price ?? 0,
      oldPrice: oldPrice,
      imageUrl: imageUrl ?? '',
      rating: rating,
      reviewCount: reviewCount,
      discount: discount,
      isFavorite: isFavorite ?? false,
      unit: unit,
      isDiscounted: isDiscounted ?? false,
      variantCount: variantCount,
      showPriceOnCard: showPriceOnCard,
    );
  }
}

extension ProductSearchResponseDtoMapper on ProductSearchResponseDto {
  ProductSearchEntity toEntity() {
    final mappedItems =
        items?.map((item) => item.toEntity()).toList() ?? const [];
    return ProductSearchEntity(
      query: query ?? '',
      total: total ?? mappedItems.length,
      page: page ?? 1,
      perPage: perPage ?? mappedItems.length,
      items: mappedItems,
    );
  }
}
