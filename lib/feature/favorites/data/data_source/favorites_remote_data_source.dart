import 'package:zadana_user_v3/feature/favorites/data/models/add_favorite_request_dto.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/add_favorite_response_dto.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/clear_favorites_response_dto.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/favorites_response_dto.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/remove_favorite_response_dto.dart';

abstract class FavoritesRemoteDataSource {
  Future<FavoritesResponseDto> getFavorites();
  Future<AddFavoriteResponseDto> addFavorite(AddFavoriteRequestDto request);
  Future<ClearFavoritesResponseDto> clearFavorites();
  Future<RemoveFavoriteResponseDto> removeFavorite(String productId);
}
