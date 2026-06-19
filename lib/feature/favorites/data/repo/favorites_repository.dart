import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/network/network_constants.dart';
import 'package:zadana_user_v3/core/services/device_id_interceptor.dart';
import 'package:zadana_user_v3/core/services/device_id_service.dart';
import 'package:zadana_user_v3/core/services/token_interceptor.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/feature/favorites/data/data_source/favorites_remote_data_source.dart';
import 'package:zadana_user_v3/feature/favorites/data/mapper/favorites_mapper.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/add_favorite_request_dto.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/favorites_response_dto.dart';
import 'package:zadana_user_v3/feature/favorites/domain/entities/add_favorite_response_entity.dart';
import 'package:zadana_user_v3/feature/favorites/domain/entities/clear_favorites_response_entity.dart';
import 'package:zadana_user_v3/feature/favorites/domain/entities/favorites_response_entity.dart';
import 'package:zadana_user_v3/feature/favorites/domain/entities/remove_favorite_response_entity.dart';

@lazySingleton
class FavoritesRepository {
  FavoritesRepository(this._remoteDataSource);

  final FavoritesRemoteDataSource _remoteDataSource;
  final StreamController<FavoriteMutationEvent> _mutationController =
      StreamController<FavoriteMutationEvent>.broadcast();
  Dio get _dio => GetIt.instance<Dio>();
  TokenService get _tokenService => GetIt.instance<TokenService>();
  DeviceIdService get _deviceIdService => GetIt.instance<DeviceIdService>();
  Stream<FavoriteMutationEvent> get mutations => _mutationController.stream;

  Future<ApiResult<FavoritesResponseEntity>> getFavorites({
    int page = 1,
    int perPage = 20,
  }) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getFavorites(
        page: page,
        perPage: perPage,
      );
      return response.toEntity();
    });
  }

  Future<ApiResult<AddFavoriteResponseEntity>> addFavorite(
    String productId,
  ) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.addFavorite(
        AddFavoriteRequestDto(productId: productId),
      );
      final entity = response.toEntity();
      emitFavoriteMutation(productIds: [productId], isFavorite: true);
      return entity;
    });
  }

  Future<ApiResult<ClearFavoritesResponseEntity>> clearFavorites() async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.clearFavorites();
      return response.toEntity();
    });
  }

  Future<ApiResult<RemoveFavoriteResponseEntity>> removeFavorite(
    String productId,
  ) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.removeFavorite(productId);
      final entity = response.toEntity();
      emitFavoriteMutation(productIds: [productId], isFavorite: false);
      return entity;
    });
  }

  Future<void> syncGuestFavoritesIfAuthenticated() async {
    final token = await _tokenService.getToken();
    if (token == null || token.isEmpty) return;

    final guestFavorites = await _loadGuestFavorites();
    if (guestFavorites == null || guestFavorites.items.isEmpty) {
      return;
    }

    for (final item in guestFavorites.items) {
      final productId = item.id;
      if (productId == null || productId.isEmpty) {
        continue;
      }

      final result = await addFavorite(productId);
      if (result is ApiSuccessResult<AddFavoriteResponseEntity>) {
        await _deleteGuestFavorite(productId);
      }
    }
  }

  Future<FavoritesResponseDto?> _loadGuestFavorites() async {
    final response = await _dio.get<Map<String, dynamic>>(
      EndPoints.favorites,
      options: await _guestOptions(),
    );

    final data = response.data;
    if (data == null) {
      return null;
    }

    return FavoritesResponseDto.fromJson(data);
  }

  Future<void> _deleteGuestFavorite(String productId) async {
    await _dio.delete<void>(
      '${EndPoints.favorites}/$productId',
      options: await _guestOptions(),
    );
  }

  Future<Options> _guestOptions() async {
    final deviceId = await _deviceIdService.getOrCreateDeviceId();
    return Options(
      headers: {NetworkConstants.deviceIdHeader: deviceId},
      extra: {
        TokenInterceptor.skipAuthKey: true,
        DeviceIdInterceptor.forceDeviceIdKey: true,
      },
    );
  }

  void emitFavoriteMutation({
    required Iterable<String> productIds,
    required bool isFavorite,
    bool skipBackgroundRefresh = false,
  }) {
    final normalizedProductIds = productIds
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList(growable: false);

    if (normalizedProductIds.isEmpty) {
      return;
    }

    _mutationController.add(
      FavoriteMutationEvent(
        productIds: normalizedProductIds,
        isFavorite: isFavorite,
        skipBackgroundRefresh: skipBackgroundRefresh,
      ),
    );
  }
}

class FavoriteMutationEvent {
  const FavoriteMutationEvent({
    required this.productIds,
    required this.isFavorite,
    this.skipBackgroundRefresh = false,
  });

  final List<String> productIds;
  final bool isFavorite;
  final bool skipBackgroundRefresh;
}
