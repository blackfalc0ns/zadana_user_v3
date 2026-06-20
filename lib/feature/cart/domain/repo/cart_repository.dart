import 'dart:async';

import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/add_cart_item_request_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/add_cart_item_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_vendors_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/clear_cart_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/delivery_check_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/get_cart_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/remove_cart_item_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/update_cart_item_quantity_request_entity.dart';

abstract class CartRepository {
  Stream<CartMutationEvent> get mutations;
  Future<ApiResult<CartVendorsEntity>> getCartVendors({
    int limit = 20,
    int offset = 0,
  });
  Future<ApiResult<AddCartItemResponseEntity>> addCartItem(
    AddCartItemRequestEntity request,
  );
  Future<void> syncGuestCartIfAuthenticated();
  Future<ApiResult<GetCartResponseEntity>> getCart({
    String? vendorId,
    int limit = 20,
    int offset = 0,
  });
  Future<ApiResult<ClearCartResponseEntity>> clearCart();
  Future<ApiResult<RemoveCartItemResponseEntity>> removeCartItem(String itemId);
  Future<ApiResult<AddCartItemResponseEntity>> updateCartItemQuantity({
    required String itemId,
    String? vendorId,
    required UpdateCartItemQuantityRequestEntity request,
  });
  Future<ApiResult<DeliveryCheckEntity>> checkDelivery({
    required String vendorId,
    required String addressId,
  });
}

class CartMutationEvent {
  const CartMutationEvent({
    this.absoluteCount,
    this.delta = 0,
    this.refreshRequested = false,
  });

  const CartMutationEvent.setCount(int count)
    : absoluteCount = count,
      delta = 0,
      refreshRequested = false;

  const CartMutationEvent.adjustCount(
    this.delta, {
    this.refreshRequested = false,
  }) : absoluteCount = null,
       assert(delta != 0 || refreshRequested);

  final int? absoluteCount;
  final int delta;
  final bool refreshRequested;
}
