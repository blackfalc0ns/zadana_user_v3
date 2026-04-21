import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/core/network/network_constants.dart';
import 'package:zadana_user_v3/core/services/device_id_interceptor.dart';
import 'package:zadana_user_v3/core/services/device_id_service.dart';
import 'package:zadana_user_v3/core/services/token_interceptor.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/feature/cart/data/data_source/cart_remote_data_source.dart';
import 'package:zadana_user_v3/feature/cart/data/models/cart_vendors_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/request/add_cart_item_request_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/request/update_cart_item_quantity_request_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/add_cart_item_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/clear_cart_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/get_cart_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/remove_cart_item_response_dto.dart';

@Injectable(as: CartRemoteDataSource)
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  const CartRemoteDataSourceImpl(
    this._apiServices,
    this._dio,
    this._cacheStore,
    this._tokenService,
    this._deviceIdService,
  );

  final ApiServices _apiServices;
  final Dio _dio;
  final CacheStore _cacheStore;
  final TokenService _tokenService;
  final DeviceIdService _deviceIdService;
  static const String _checkoutSummaryEndpoint = '/checkout/summary';

  static const Map<String, String> _noStoreHeaders = {
    'Cache-Control': 'no-store, no-cache, must-revalidate',
    'Pragma': 'no-cache',
    'Expires': '0',
  };

  Options _noCacheOptions({
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) {
    return Options(
      headers: {..._noStoreHeaders, ...?headers},
      extra: {
        ...?extra,
        ...CacheOptions(
          store: _cacheStore,
          policy: CachePolicy.noCache,
        ).toExtra(),
      },
    );
  }

  Future<bool> _shouldFallbackToGuest(DioException error) async {
    final token = await _tokenService.getToken();
    // Never mix authenticated and guest carts. If an authenticated request
    // fails with 401, surface the error instead of silently reading the guest
    // cart and showing stale items after checkout.
    return error.response?.statusCode == 401 &&
        (token == null || token.isEmpty);
  }

  Future<Options> _guestNoCacheOptions() async {
    final deviceId = await _deviceIdService.getOrCreateDeviceId();
    return _noCacheOptions(
      headers: {NetworkConstants.deviceIdHeader: deviceId},
      extra: {
        TokenInterceptor.skipAuthKey: true,
        DeviceIdInterceptor.forceDeviceIdKey: true,
      },
    );
  }

  Future<void> _clearCartReadCache() {
    return _clearCachedPath(EndPoints.cart);
  }

  Future<void> _clearCheckoutSummaryCache() {
    return _clearCachedPath(_checkoutSummaryEndpoint);
  }

  Future<void> _clearCachedPath(String endpoint) {
    return _cacheStore.deleteFromPath(_buildEndpointPattern(endpoint));
  }

  RegExp _buildEndpointPattern(String endpoint) {
    return RegExp(
      '^${RegExp.escape('${NetworkConstants.baseUrl}$endpoint')}(?:[/?].*)?\$',
    );
  }

  @override
  Future<CartVendorsResponseDto> getCartVendors() async {
    await _clearCartReadCache();

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        EndPoints.cartVendors,
        options: _noCacheOptions(),
      );
      return CartVendorsResponseDto.fromJson(response.data ?? {});
    } on DioException catch (error) {
      if (!await _shouldFallbackToGuest(error)) rethrow;

      final response = await _dio.get<Map<String, dynamic>>(
        EndPoints.cartVendors,
        options: await _guestNoCacheOptions(),
      );

      return CartVendorsResponseDto.fromJson(response.data ?? {});
    }
  }

  @override
  Future<AddCartItemResponseDto> addCartItem(
    AddCartItemRequestDto request,
  ) async {
    try {
      final response = await _apiServices.addCartItem(request);
      await _clearCartReadCache();
      return response;
    } on DioException catch (error) {
      if (!await _shouldFallbackToGuest(error)) rethrow;

      final response = await _dio.post<Map<String, dynamic>>(
        EndPoints.cartItems,
        data: request.toJson(),
        options: await _guestNoCacheOptions(),
      );

      await _clearCartReadCache();
      return AddCartItemResponseDto.fromJson(response.data ?? {});
    }
  }

  @override
  Future<GetCartResponseDto> getCart({String? vendorId}) async {
    await _clearCartReadCache();

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        EndPoints.cart,
        queryParameters: {
          if (vendorId != null && vendorId.isNotEmpty) 'vendor_id': vendorId,
        },
        options: _noCacheOptions(),
      );
      return GetCartResponseDto.fromJson(response.data ?? {});
    } on DioException catch (error) {
      if (!await _shouldFallbackToGuest(error)) rethrow;

      final response = await _dio.get<Map<String, dynamic>>(
        EndPoints.cart,
        queryParameters: {
          if (vendorId != null && vendorId.isNotEmpty) 'vendor_id': vendorId,
        },
        options: await _guestNoCacheOptions(),
      );

      return GetCartResponseDto.fromJson(response.data ?? {});
    }
  }

  @override
  Future<ClearCartResponseDto> clearCart() async {
    try {
      final response = await _apiServices.clearCart();
      await _clearCartReadCache();
      await _clearCheckoutSummaryCache();
      return response;
    } on DioException catch (error) {
      if (!await _shouldFallbackToGuest(error)) rethrow;

      final response = await _dio.delete<Map<String, dynamic>>(
        EndPoints.cart,
        options: await _guestNoCacheOptions(),
      );

      await _clearCartReadCache();
      await _clearCheckoutSummaryCache();
      return ClearCartResponseDto.fromJson(response.data ?? {});
    }
  }

  @override
  Future<RemoveCartItemResponseDto> removeCartItem(String itemId) async {
    try {
      final response = await _apiServices.removeCartItem(itemId);
      await _clearCartReadCache();
      await _clearCheckoutSummaryCache();
      return response;
    } on DioException catch (error) {
      if (!await _shouldFallbackToGuest(error)) rethrow;

      final response = await _dio.delete<Map<String, dynamic>>(
        '${EndPoints.cartItems}/$itemId',
        options: await _guestNoCacheOptions(),
      );

      await _clearCartReadCache();
      await _clearCheckoutSummaryCache();
      return RemoveCartItemResponseDto.fromJson(response.data ?? {});
    }
  }

  @override
  Future<AddCartItemResponseDto> updateCartItemQuantity(
    String itemId,
    String? vendorId,
    UpdateCartItemQuantityRequestDto request,
  ) async {
    final response = await _apiServices.updateCartItemQuantity(
      itemId,
      vendorId,
      request,
    );
    await _clearCartReadCache();
    await _clearCheckoutSummaryCache();
    return response;
  }
}
