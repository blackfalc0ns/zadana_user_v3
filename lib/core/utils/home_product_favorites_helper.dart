import 'package:dio/dio.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/core/services/device_id_service.dart';
import 'package:zadana_user_v3/core/services/favorite_sync_service.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/feature/favorites/data/data_source/favorites_remote_data_source_impl.dart';
import 'package:zadana_user_v3/feature/favorites/data/repo/favorites_repository.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class FavoriteActionResult {
  const FavoriteActionResult({
    required this.isSuccess,
    required this.message,
  });

  final bool isSuccess;
  final String message;
}

class HomeProductFavoritesHelper {
  const HomeProductFavoritesHelper._();

  static Future<FavoriteActionResult> addProductToFavorites(
    ProductModel product,
  ) async {
    if (product.isFavorite) {
      return const FavoriteActionResult(isSuccess: true, message: '');
    }

    final repository = FavoritesRepository(
      FavoritesRemoteDataSourceImpl(
        getIt<ApiServices>(),
        getIt<Dio>(),
        getIt<TokenService>(),
        getIt<DeviceIdService>(),
      ),
    );

    final result = await repository.addFavorite(product.id);

    switch (result) {
      case ApiSuccessResult():
        FavoriteSyncService().notifyFavoriteChanged(
          productId: product.id,
          isFavorite: true,
        );
        return FavoriteActionResult(
          isSuccess: true,
          message: result.data.message,
        );
      case ApiErrorResult():
        return FavoriteActionResult(
          isSuccess: false,
          message: result.failure.errorMessage,
        );
    }
  }

  static Future<FavoriteActionResult> removeProductFromFavorites(
    ProductModel product,
  ) async {
    final repository = FavoritesRepository(
      FavoritesRemoteDataSourceImpl(
        getIt<ApiServices>(),
        getIt<Dio>(),
        getIt<TokenService>(),
        getIt<DeviceIdService>(),
      ),
    );

    final result = await repository.removeFavorite(product.id);

    switch (result) {
      case ApiSuccessResult():
        FavoriteSyncService().notifyFavoriteChanged(
          productId: product.id,
          isFavorite: false,
        );
        return FavoriteActionResult(
          isSuccess: true,
          message: result.data.message,
        );
      case ApiErrorResult():
        return FavoriteActionResult(
          isSuccess: false,
          message: result.failure.errorMessage,
        );
    }
  }
}
