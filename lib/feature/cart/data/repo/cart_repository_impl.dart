import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/network/network_constants.dart';
import 'package:zadana_user_v3/core/services/device_id_interceptor.dart';
import 'package:zadana_user_v3/core/services/device_id_service.dart';
import 'package:zadana_user_v3/core/services/guest_cart_signature_service.dart';
import 'package:zadana_user_v3/core/services/token_interceptor.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/feature/cart/data/data_source/cart_remote_data_source.dart';
import 'package:zadana_user_v3/feature/cart/data/mapper/add_cart_item_mapper.dart';
import 'package:zadana_user_v3/feature/cart/data/mapper/cart_vendor_mapper.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/get_cart_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/add_cart_item_request_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/add_cart_item_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_vendors_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/clear_cart_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/delivery_check_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/get_cart_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/remove_cart_item_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/update_cart_item_quantity_request_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/repo/cart_repository.dart';

@LazySingleton(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl(this._remoteDataSource);

  final CartRemoteDataSource _remoteDataSource;
  final StreamController<CartMutationEvent> _mutationController =
      StreamController<CartMutationEvent>.broadcast();
  Dio get _dio => GetIt.instance<Dio>();
  TokenService get _tokenService => GetIt.instance<TokenService>();
  DeviceIdService get _deviceIdService => GetIt.instance<DeviceIdService>();
  @override
  Stream<CartMutationEvent> get mutations => _mutationController.stream;

  @override
  Future<ApiResult<CartVendorsEntity>> getCartVendors({
    int limit = 20,
    int offset = 0,
  }) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCartVendors(
        limit: limit,
        offset: offset,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<AddCartItemResponseEntity>> addCartItem(
    AddCartItemRequestEntity request,
  ) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.addCartItem(request.toDto());
      final entity = response.toEntity();
      _emitMutation(
        CartMutationEvent.adjustCount(request.quantity, refreshRequested: true),
      );
      return entity;
    });
  }

  @override
  Future<void> syncGuestCartIfAuthenticated() async {
    final token = await _tokenService.getToken();
    if (token == null || token.isEmpty) return;

    final guestCart = await _loadGuestCart();
    if (guestCart == null || guestCart.items.isEmpty) {
      return;
    }

    for (final item in guestCart.items) {
      final result = await addCartItem(
        AddCartItemRequestEntity(
          productId: item.productId,
          quantity: item.quantity,
        ),
      );

      if (result is ApiSuccessResult<AddCartItemResponseEntity>) {
        await _deleteGuestCartItem(item.id);
      }
    }
  }

  @override
  Future<ApiResult<GetCartResponseEntity>> getCart({
    String? vendorId,
    int limit = 20,
    int offset = 0,
  }) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCart(
        vendorId: vendorId,
        limit: limit,
        offset: offset,
      );
      final entity = response.toEntity();
      _emitMutation(CartMutationEvent.setCount(entity.summary.totalQuantity));
      return entity;
    });
  }

  @override
  Future<ApiResult<ClearCartResponseEntity>> clearCart() async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.clearCart();
      final entity = response.toEntity();
      _emitMutation(const CartMutationEvent.setCount(0));
      return entity;
    });
  }

  @override
  Future<ApiResult<RemoveCartItemResponseEntity>> removeCartItem(
    String itemId,
  ) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.removeCartItem(itemId);
      final entity = response.toEntity();
      _emitMutation(CartMutationEvent.setCount(entity.summary.totalQuantity));
      return entity;
    });
  }

  @override
  Future<ApiResult<AddCartItemResponseEntity>> updateCartItemQuantity({
    required String itemId,
    String? vendorId,
    required UpdateCartItemQuantityRequestEntity request,
  }) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.updateCartItemQuantity(
        itemId,
        vendorId,
        request.toDto(),
      );
      final entity = response.toEntity();
      _emitMutation(CartMutationEvent.setCount(entity.summary.totalQuantity));
      return entity;
    });
  }

  @override
  Future<ApiResult<DeliveryCheckEntity>> checkDelivery({
    required String vendorId,
    required String addressId,
  }) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.checkDelivery(
        vendorId: vendorId,
        addressId: addressId,
      );
      return response.toEntity();
    });
  }

  Future<GetCartResponseDto?> _loadGuestCart() async {
    final response = await _dio.get<Map<String, dynamic>>(
      EndPoints.cart,
      options: await _guestOptions(),
    );

    final data = response.data;
    if (data == null) {
      return null;
    }

    return GetCartResponseDto.fromJson(data);
  }

  Future<void> _deleteGuestCartItem(String itemId) async {
    await _dio.delete<void>(
      '${EndPoints.cartItems}/$itemId',
      options: await _guestOptions(isMutation: true),
    );
  }

  Future<Options> _guestOptions({bool isMutation = false}) async {
    final deviceId = await _deviceIdService.getOrCreateDeviceId();
    final headers = <String, dynamic>{
      NetworkConstants.deviceIdHeader: deviceId,
    };

    if (isMutation) {
      try {
        final signatureService =
            GetIt.instance<GuestCartSignatureService>();
        final signature = await signatureService.getOrFetchSignature();
        if (signature != null && signature.isNotEmpty) {
          headers[NetworkConstants.deviceSignatureHeader] = signature;
        }
      } catch (_) {
        // Signature service not registered or failed — proceed without.
      }
    }

    return Options(
      headers: headers,
      extra: {
        TokenInterceptor.skipAuthKey: true,
        DeviceIdInterceptor.forceDeviceIdKey: true,
      },
    );
  }

  void _emitMutation(CartMutationEvent event) {
    _mutationController.add(event);
  }
}
