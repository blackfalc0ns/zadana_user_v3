import 'package:zadana_user_v3/feature/cart/data/models/request/add_cart_item_request_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/request/update_cart_item_quantity_request_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/add_cart_item_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/cart_item_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/cart_summary_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/clear_cart_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/get_cart_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/remove_cart_item_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/vendor_price_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/add_cart_item_request_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/add_cart_item_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_summary_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/clear_cart_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/get_cart_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/remove_cart_item_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/update_cart_item_quantity_request_entity.dart';

extension AddCartItemRequestEntityMapper on AddCartItemRequestEntity {
  AddCartItemRequestDto toDto() {
    return AddCartItemRequestDto(productId: productId, quantity: quantity);
  }
}

extension UpdateCartItemQuantityRequestEntityMapper
    on UpdateCartItemQuantityRequestEntity {
  UpdateCartItemQuantityRequestDto toDto() {
    return UpdateCartItemQuantityRequestDto(quantity: quantity);
  }
}

extension VendorPriceResponseDtoMapper on VendorPriceResponseDto {
  VendorPrice toEntity() {
    return VendorPrice(
      id: id,
      name: name,
      price: price,
      oldPrice: oldPrice,
      isDiscounted: isDiscounted,
    );
  }
}

extension CartItemResponseDtoMapper on CartItemResponseDto {
  CartItemModel toEntity() {
    return CartItemModel(
      id: id,
      productId: productId,
      name: name,
      imageUrl: imageUrl,
      unit: unit,
      quantity: quantity,
      vendorPrices: vendorPrices.map((price) => price.toEntity()).toList(),
    );
  }
}

extension CartSummaryResponseDtoMapper on CartSummaryResponseDto {
  CartSummaryEntity toEntity() {
    return CartSummaryEntity(
      itemsCount: itemsCount,
      totalQuantity: totalQuantity,
    );
  }
}

extension AddCartItemResponseDtoMapper on AddCartItemResponseDto {
  AddCartItemResponseEntity toEntity() {
    return AddCartItemResponseEntity(
      message: message,
      item: item.toEntity(),
      summary: summary.toEntity(),
    );
  }
}

extension ClearCartResponseDtoMapper on ClearCartResponseDto {
  ClearCartResponseEntity toEntity() {
    return ClearCartResponseEntity(message: message);
  }
}

extension RemoveCartItemResponseDtoMapper on RemoveCartItemResponseDto {
  RemoveCartItemResponseEntity toEntity() {
    return RemoveCartItemResponseEntity(
      message: message,
      summary: summary.toEntity(),
    );
  }
}

extension GetCartResponseDtoMapper on GetCartResponseDto {
  GetCartResponseEntity toEntity() {
    return GetCartResponseEntity(
      items: items.map((item) => item.toEntity()).toList(),
      summary: summary.toEntity(),
    );
  }
}
