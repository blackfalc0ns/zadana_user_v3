import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/add_cart_item_request_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/add_cart_item_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_vendors_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/clear_cart_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/get_cart_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/remove_cart_item_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/update_cart_item_quantity_request_entity.dart';

abstract class CartRepository {
  Future<ApiResult<CartVendorsEntity>> getCartVendors();
  Future<ApiResult<AddCartItemResponseEntity>> addCartItem(
    AddCartItemRequestEntity request,
  );
  Future<ApiResult<GetCartResponseEntity>> getCart({String? vendorId});
  Future<ApiResult<ClearCartResponseEntity>> clearCart();
  Future<ApiResult<RemoveCartItemResponseEntity>> removeCartItem(String itemId);
  Future<ApiResult<AddCartItemResponseEntity>> updateCartItemQuantity({
    required String itemId,
    required UpdateCartItemQuantityRequestEntity request,
  });
}
