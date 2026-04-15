import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/favorites/data/data_source/favorites_remote_data_source.dart';
import 'package:zadana_user_v3/feature/favorites/data/mapper/favorites_mapper.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/add_favorite_request_dto.dart';
import 'package:zadana_user_v3/feature/favorites/data/services/guest_favorites_sync_service.dart';
import 'package:zadana_user_v3/feature/favorites/domain/entities/add_favorite_response_entity.dart';
import 'package:zadana_user_v3/feature/favorites/domain/entities/clear_favorites_response_entity.dart';
import 'package:zadana_user_v3/feature/favorites/domain/entities/favorites_response_entity.dart';
import 'package:zadana_user_v3/feature/favorites/domain/entities/remove_favorite_response_entity.dart';

class FavoritesRepository {
  const FavoritesRepository(this._remoteDataSource);

  final FavoritesRemoteDataSource _remoteDataSource;

  Future<ApiResult<FavoritesResponseEntity>> getFavorites() async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getFavorites();
      final entity = response.toEntity();
      await GuestFavoritesSyncService().replaceGuestFavorites(
        entity.items.map((item) => item.id),
      );
      return entity;
    });
  }

  Future<ApiResult<AddFavoriteResponseEntity>> addFavorite(String productId) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.addFavorite(
        AddFavoriteRequestDto(productId: productId),
      );
      await GuestFavoritesSyncService().cacheGuestFavorite(productId);
      return response.toEntity();
    });
  }

  Future<ApiResult<ClearFavoritesResponseEntity>> clearFavorites() async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.clearFavorites();
      await GuestFavoritesSyncService().clearPendingFavorites();
      return response.toEntity();
    });
  }

  Future<ApiResult<RemoveFavoriteResponseEntity>> removeFavorite(
    String productId,
  ) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.removeFavorite(productId);
      await GuestFavoritesSyncService().removeGuestFavorite(productId);
      return response.toEntity();
    });
  }
}
