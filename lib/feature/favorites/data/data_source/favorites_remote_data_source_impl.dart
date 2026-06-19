import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/core/network/network_constants.dart';
import 'package:zadana_user_v3/core/services/device_id_interceptor.dart';
import 'package:zadana_user_v3/core/services/device_id_service.dart';
import 'package:zadana_user_v3/core/services/token_interceptor.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/feature/favorites/data/data_source/favorites_remote_data_source.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/add_favorite_request_dto.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/add_favorite_response_dto.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/clear_favorites_response_dto.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/favorites_response_dto.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/remove_favorite_response_dto.dart';

@Injectable(as: FavoritesRemoteDataSource)
class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  const FavoritesRemoteDataSourceImpl(
    this._apiServices,
    this._dio,
    this._tokenService,
    this._deviceIdService,
  );

  final ApiServices _apiServices;
  final Dio _dio;
  final TokenService _tokenService;
  final DeviceIdService _deviceIdService;

  @override
  Future<FavoritesResponseDto> getFavorites({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        EndPoints.favorites,
        queryParameters: {'page': page, 'per_page': perPage},
      );
      return FavoritesResponseDto.fromJson(response.data ?? {});
    } on DioException catch (error) {
      final token = await _tokenService.getToken();
      final shouldFallbackToGuest =
          error.response?.statusCode == 401 &&
          token != null &&
          token.isNotEmpty;

      if (!shouldFallbackToGuest) rethrow;

      final deviceId = await _deviceIdService.getOrCreateDeviceId();
      final response = await _dio.get<Map<String, dynamic>>(
        EndPoints.favorites,
        queryParameters: {'page': page, 'per_page': perPage},
        options: Options(
          headers: {NetworkConstants.deviceIdHeader: deviceId},
          extra: {
            TokenInterceptor.skipAuthKey: true,
            DeviceIdInterceptor.forceDeviceIdKey: true,
          },
        ),
      );

      return FavoritesResponseDto.fromJson(response.data ?? {});
    }
  }

  @override
  Future<AddFavoriteResponseDto> addFavorite(
    AddFavoriteRequestDto request,
  ) async {
    try {
      return await _apiServices.addFavorite(request);
    } on DioException catch (error) {
      final token = await _tokenService.getToken();
      final shouldFallbackToGuest =
          error.response?.statusCode == 401 &&
          token != null &&
          token.isNotEmpty;

      if (!shouldFallbackToGuest) rethrow;

      final deviceId = await _deviceIdService.getOrCreateDeviceId();
      final response = await _dio.post<Map<String, dynamic>>(
        EndPoints.favorites,
        data: request.toJson(),
        options: Options(
          headers: {NetworkConstants.deviceIdHeader: deviceId},
          extra: {
            TokenInterceptor.skipAuthKey: true,
            DeviceIdInterceptor.forceDeviceIdKey: true,
          },
        ),
      );

      return AddFavoriteResponseDto.fromJson(response.data ?? {});
    }
  }

  @override
  Future<ClearFavoritesResponseDto> clearFavorites() async {
    try {
      return await _apiServices.clearFavorites();
    } on DioException catch (error) {
      final token = await _tokenService.getToken();
      final shouldFallbackToGuest =
          error.response?.statusCode == 401 &&
          token != null &&
          token.isNotEmpty;

      if (!shouldFallbackToGuest) rethrow;

      final deviceId = await _deviceIdService.getOrCreateDeviceId();
      final response = await _dio.delete<Map<String, dynamic>>(
        EndPoints.favorites,
        options: Options(
          headers: {NetworkConstants.deviceIdHeader: deviceId},
          extra: {
            TokenInterceptor.skipAuthKey: true,
            DeviceIdInterceptor.forceDeviceIdKey: true,
          },
        ),
      );

      return ClearFavoritesResponseDto.fromJson(response.data ?? {});
    }
  }

  @override
  Future<RemoveFavoriteResponseDto> removeFavorite(String productId) async {
    try {
      return await _apiServices.removeFavorite(productId);
    } on DioException catch (error) {
      final token = await _tokenService.getToken();
      final shouldFallbackToGuest =
          error.response?.statusCode == 401 &&
          token != null &&
          token.isNotEmpty;

      if (!shouldFallbackToGuest) rethrow;

      final deviceId = await _deviceIdService.getOrCreateDeviceId();
      final response = await _dio.delete<Map<String, dynamic>>(
        '${EndPoints.favorites}/$productId',
        options: Options(
          headers: {NetworkConstants.deviceIdHeader: deviceId},
          extra: {
            TokenInterceptor.skipAuthKey: true,
            DeviceIdInterceptor.forceDeviceIdKey: true,
          },
        ),
      );

      return RemoveFavoriteResponseDto.fromJson(response.data ?? {});
    }
  }
}
