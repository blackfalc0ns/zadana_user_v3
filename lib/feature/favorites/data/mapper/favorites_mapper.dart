import 'package:zadana_user_v3/feature/favorites/data/models/add_favorite_response_dto.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/clear_favorites_response_dto.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/favorites_item_dto.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/favorites_response_dto.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/remove_favorite_response_dto.dart';
import 'package:zadana_user_v3/feature/favorites/domain/entities/add_favorite_response_entity.dart';
import 'package:zadana_user_v3/feature/favorites/domain/entities/clear_favorites_response_entity.dart';
import 'package:zadana_user_v3/feature/favorites/domain/entities/favorites_response_entity.dart';
import 'package:zadana_user_v3/feature/favorites/domain/entities/remove_favorite_response_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

extension FavoritesItemDtoMapper on FavoritesItemDto {
  ProductModel toEntity() {
    return ProductModel(
      id: id ?? '',
      name: name ?? '',
      store: store ?? '',
      price: price ?? 0,
      oldPrice: oldPrice,
      imageUrl: imageUrl ?? '',
      rating: rating,
      reviewCount: reviewCount ?? 0,
      discount: discount,
      isFavorite: isFavorite ?? true,
      unit: unit,
      emoji: '',
      isDiscounted: isDiscounted ?? false,
      showPriceOnCard: showPriceOnCard,
    );
  }
}

extension FavoritesResponseDtoMapper on FavoritesResponseDto {
  FavoritesResponseEntity toEntity() {
    return FavoritesResponseEntity(
      items: items.map((item) => item.toEntity()).toList(),
      itemsCount: summary.itemsCount,
    );
  }
}

extension AddFavoriteResponseDtoMapper on AddFavoriteResponseDto {
  AddFavoriteResponseEntity toEntity() {
    return AddFavoriteResponseEntity(
      message: message,
      item: item.toEntity(),
      itemsCount: summary.itemsCount,
    );
  }
}

extension ClearFavoritesResponseDtoMapper on ClearFavoritesResponseDto {
  ClearFavoritesResponseEntity toEntity() {
    return ClearFavoritesResponseEntity(message: message);
  }
}

extension RemoveFavoriteResponseDtoMapper on RemoveFavoriteResponseDto {
  RemoveFavoriteResponseEntity toEntity() {
    return RemoveFavoriteResponseEntity(
      message: message,
      itemsCount: summary.itemsCount,
    );
  }
}
