import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/cart/data/data_source/cart_remote_data_source.dart';
import 'package:zadana_user_v3/feature/cart/data/mapper/add_cart_item_mapper.dart';
import 'package:zadana_user_v3/feature/cart/data/mapper/cart_vendor_mapper.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/add_cart_item_request_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/add_cart_item_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_vendors_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/clear_cart_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/get_cart_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/remove_cart_item_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/update_cart_item_quantity_request_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/repo/cart_repository.dart';

@Injectable(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  const CartRepositoryImpl(this._remoteDataSource);

  final CartRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<CartVendorsEntity>> getCartVendors() async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCartVendors();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<AddCartItemResponseEntity>> addCartItem(
    AddCartItemRequestEntity request,
  ) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.addCartItem(request.toDto());
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<GetCartResponseEntity>> getCart({String? vendorId}) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCart(vendorId: vendorId);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<ClearCartResponseEntity>> clearCart() async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.clearCart();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<RemoveCartItemResponseEntity>> removeCartItem(
    String itemId,
  ) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.removeCartItem(itemId);
      return response.toEntity();
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
      return response.toEntity();
    });
  }
}
