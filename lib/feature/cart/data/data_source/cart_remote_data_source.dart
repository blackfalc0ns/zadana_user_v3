import 'package:zadana_user_v3/feature/cart/data/models/cart_vendors_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/request/add_cart_item_request_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/request/update_cart_item_quantity_request_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/add_cart_item_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/clear_cart_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/delivery_check_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/get_cart_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/remove_cart_item_response_dto.dart';

abstract class CartRemoteDataSource {
  Future<CartVendorsResponseDto> getCartVendors({
    int limit = 20,
    int offset = 0,
  });
  Future<AddCartItemResponseDto> addCartItem(AddCartItemRequestDto request);
  Future<GetCartResponseDto> getCart({
    String? vendorId,
    int limit = 20,
    int offset = 0,
  });
  Future<ClearCartResponseDto> clearCart();
  Future<RemoveCartItemResponseDto> removeCartItem(String itemId);
  Future<AddCartItemResponseDto> updateCartItemQuantity(
    String itemId,
    String? vendorId,
    UpdateCartItemQuantityRequestDto request,
  );
  Future<DeliveryCheckResponseDto> checkDelivery({
    required String vendorId,
    required String addressId,
  });
}
