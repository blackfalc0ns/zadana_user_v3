import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/core/services/device_id_service.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/core/utils/constants.dart';
import 'package:zadana_user_v3/feature/favorites/data/data_source/favorites_remote_data_source_impl.dart';
import 'package:zadana_user_v3/feature/favorites/data/repo/favorites_repository.dart';

class GuestFavoritesSyncService {
  GuestFavoritesSyncService._internal();

  factory GuestFavoritesSyncService() => _instance;

  static final GuestFavoritesSyncService _instance =
      GuestFavoritesSyncService._internal();

  SharedPreferences get _sharedPreferences =>
      GetIt.instance<SharedPreferences>();
  TokenService get _tokenService => GetIt.instance<TokenService>();

  FavoritesRepository _buildRepository() {
    final getIt = GetIt.instance;
    return FavoritesRepository(
      FavoritesRemoteDataSourceImpl(
        getIt<ApiServices>(),
        getIt<Dio>(),
        getIt<TokenService>(),
        getIt<DeviceIdService>(),
      ),
    );
  }

  Future<void> cacheGuestFavorite(String productId) async {
    if (await _isAuthenticated()) {
      return;
    }

    final currentIds = await _getPendingProductIds();
    if (currentIds.contains(productId)) {
      return;
    }

    await _savePendingProductIds([...currentIds, productId]);
  }

  Future<void> removeGuestFavorite(String productId) async {
    if (await _isAuthenticated()) {
      return;
    }

    final currentIds = await _getPendingProductIds();
    await _savePendingProductIds(
      currentIds.where((id) => id != productId).toList(),
    );
  }

  Future<void> replaceGuestFavorites(Iterable<String> productIds) async {
    if (await _isAuthenticated()) {
      return;
    }

    await _savePendingProductIds(productIds.toSet().toList());
  }

  Future<void> clearPendingFavorites() async {
    await _sharedPreferences.remove(
      AppConstants.pendingGuestFavoriteProductIdsKey,
    );
  }

  Future<void> syncPendingFavoritesIfAuthenticated() async {
    if (!await _isAuthenticated()) {
      return;
    }

    final pendingProductIds = await _getPendingProductIds();
    if (pendingProductIds.isEmpty) {
      return;
    }

    final repository = _buildRepository();
    final failedProductIds = <String>[];

    for (final productId in pendingProductIds) {
      final result = await repository.addFavorite(productId);
      if (result is ApiErrorResult) {
        failedProductIds.add(productId);
      }
    }

    await _savePendingProductIds(failedProductIds);
  }

  Future<bool> _isAuthenticated() async {
    final token = await _tokenService.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<List<String>> _getPendingProductIds() async {
    return _sharedPreferences.getStringList(
          AppConstants.pendingGuestFavoriteProductIdsKey,
        ) ??
        const <String>[];
  }

  Future<void> _savePendingProductIds(List<String> productIds) async {
    await _sharedPreferences.setStringList(
      AppConstants.pendingGuestFavoriteProductIdsKey,
      productIds,
    );
  }
}
