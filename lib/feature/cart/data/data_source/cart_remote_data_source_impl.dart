import 'package:dio/dio.dart';
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
    this._tokenService,
    this._deviceIdService,
  );

  final ApiServices _apiServices;
  final Dio _dio;
  final TokenService _tokenService;
  final DeviceIdService _deviceIdService;

  @override
  Future<CartVendorsResponseDto> getCartVendors() async {
    try {
      return await _apiServices.getCartVendors();
    } on DioException catch (error) {
      final token = await _tokenService.getToken();
      final shouldFallbackToGuest =
          error.response?.statusCode == 401 &&
          token != null &&
          token.isNotEmpty;

      if (!shouldFallbackToGuest) rethrow;

      final deviceId = await _deviceIdService.getOrCreateDeviceId();
      final response = await _dio.get<Map<String, dynamic>>(
        EndPoints.cartVendors,
        options: Options(
          headers: {NetworkConstants.deviceIdHeader: deviceId},
          extra: {
            TokenInterceptor.skipAuthKey: true,
            DeviceIdInterceptor.forceDeviceIdKey: true,
          },
        ),
      );

      return CartVendorsResponseDto.fromJson(response.data ?? {});
    }
  }

  @override
  Future<AddCartItemResponseDto> addCartItem(
    AddCartItemRequestDto request,
  ) async {
    try {
      return await _apiServices.addCartItem(request);
    } on DioException catch (error) {
      final token = await _tokenService.getToken();
      final shouldFallbackToGuest =
          error.response?.statusCode == 401 &&
          token != null &&
          token.isNotEmpty;

      if (!shouldFallbackToGuest) rethrow;

      final deviceId = await _deviceIdService.getOrCreateDeviceId();
      final response = await _dio.post<Map<String, dynamic>>(
        EndPoints.cartItems,
        data: request.toJson(),
        options: Options(
          headers: {NetworkConstants.deviceIdHeader: deviceId},
          extra: {
            TokenInterceptor.skipAuthKey: true,
            DeviceIdInterceptor.forceDeviceIdKey: true,
          },
        ),
      );

      return AddCartItemResponseDto.fromJson(response.data ?? {});
    }
  }

  @override
  Future<GetCartResponseDto> getCart({String? vendorId}) async {
    try {
      return await _apiServices.getCart(vendorId);
    } on DioException catch (error) {
      final token = await _tokenService.getToken();
      final shouldFallbackToGuest =
          error.response?.statusCode == 401 &&
          token != null &&
          token.isNotEmpty;

      if (!shouldFallbackToGuest) rethrow;

      final deviceId = await _deviceIdService.getOrCreateDeviceId();
      final response = await _dio.get<Map<String, dynamic>>(
        EndPoints.cart,
        queryParameters: {
          if (vendorId != null && vendorId.isNotEmpty) 'vendor_id': vendorId,
        },
        options: Options(
          headers: {NetworkConstants.deviceIdHeader: deviceId},
          extra: {
            TokenInterceptor.skipAuthKey: true,
            DeviceIdInterceptor.forceDeviceIdKey: true,
          },
        ),
      );

      return GetCartResponseDto.fromJson(response.data ?? {});
    }
  }

  @override
  Future<ClearCartResponseDto> clearCart() async {
    try {
      return await _apiServices.clearCart();
    } on DioException catch (error) {
      final token = await _tokenService.getToken();
      final shouldFallbackToGuest =
          error.response?.statusCode == 401 &&
          token != null &&
          token.isNotEmpty;

      if (!shouldFallbackToGuest) rethrow;

      final deviceId = await _deviceIdService.getOrCreateDeviceId();
      final response = await _dio.delete<Map<String, dynamic>>(
        EndPoints.cart,
        options: Options(
          headers: {NetworkConstants.deviceIdHeader: deviceId},
          extra: {
            TokenInterceptor.skipAuthKey: true,
            DeviceIdInterceptor.forceDeviceIdKey: true,
          },
        ),
      );

      return ClearCartResponseDto.fromJson(response.data ?? {});
    }
  }

  @override
  Future<RemoveCartItemResponseDto> removeCartItem(String itemId) async {
    try {
      return await _apiServices.removeCartItem(itemId);
    } on DioException catch (error) {
      final token = await _tokenService.getToken();
      final shouldFallbackToGuest =
          error.response?.statusCode == 401 &&
          token != null &&
          token.isNotEmpty;

      if (!shouldFallbackToGuest) rethrow;

      final deviceId = await _deviceIdService.getOrCreateDeviceId();
      final response = await _dio.delete<Map<String, dynamic>>(
        '${EndPoints.cartItems}/$itemId',
        options: Options(
          headers: {NetworkConstants.deviceIdHeader: deviceId},
          extra: {
            TokenInterceptor.skipAuthKey: true,
            DeviceIdInterceptor.forceDeviceIdKey: true,
          },
        ),
      );

      return RemoveCartItemResponseDto.fromJson(response.data ?? {});
    }
  }

  @override
  Future<AddCartItemResponseDto> updateCartItemQuantity(
    String itemId,
    UpdateCartItemQuantityRequestDto request,
  ) async {
    try {
      final options = await _buildCartRequestOptions();
      final response = await _sendUpdateCartItemQuantityRequest(
        itemId: itemId,
        request: request,
        options: options,
      );
      return AddCartItemResponseDto.fromJson(response.data ?? {});
    } on DioException catch (error) {
      final token = await _tokenService.getToken();
      final shouldFallbackToGuest =
          error.response?.statusCode == 401 &&
          token != null &&
          token.isNotEmpty;

      if (!shouldFallbackToGuest) rethrow;

      final guestOptions = await _buildCartRequestOptions(forceGuest: true);
      final response = await _sendUpdateCartItemQuantityRequest(
        itemId: itemId,
        request: request,
        options: guestOptions,
      );

      return AddCartItemResponseDto.fromJson(response.data ?? {});
    }
  }

  Future<Options> _buildCartRequestOptions({bool forceGuest = false}) async {
    final token = forceGuest ? null : await _tokenService.getToken();
    if (token != null && token.isNotEmpty) {
      return Options(
        headers: {
          NetworkConstants.authorization:
              '${NetworkConstants.bearer} $token',
        },
        extra: {TokenInterceptor.skipAuthKey: true},
      );
    }

    final deviceId = await _deviceIdService.getOrCreateDeviceId();
    return Options(
      headers: {NetworkConstants.deviceIdHeader: deviceId},
      extra: {
        TokenInterceptor.skipAuthKey: true,
        DeviceIdInterceptor.forceDeviceIdKey: true,
      },
    );
  }

  Future<Response<Map<String, dynamic>>> _sendUpdateCartItemQuantityRequest({
    required String itemId,
    required UpdateCartItemQuantityRequestDto request,
    required Options options,
  }) async {
    try {
      return await _dio.patch<Map<String, dynamic>>(
        '${EndPoints.cartItems}/$itemId',
        data: request.toJson(),
        options: options,
      );
    } on DioException catch (error) {
      if (error.response?.statusCode != 405) rethrow;

      return _dio.put<Map<String, dynamic>>(
        '${EndPoints.cartItems}/$itemId',
        data: request.toJson(),
        options: options,
      );
    }
  }
}
