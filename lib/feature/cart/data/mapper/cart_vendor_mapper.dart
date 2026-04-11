import 'package:zadana_user_v3/feature/cart/data/models/cart_vendor_item_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/cart_vendors_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_vendor_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_vendors_entity.dart';

extension CartVendorItemDtoMapper on CartVendorItemDto {
  CartVendorEntity toEntity() {
    return CartVendorEntity(
      id: id,
      name: name,
      logoUrl: logoUrl,
      productsCount: productsCount,
    );
  }
}

extension CartVendorsResponseDtoMapper on CartVendorsResponseDto {
  CartVendorsEntity toEntity() {
    return CartVendorsEntity(
      vendors: vendors.map((vendor) => vendor.toEntity()).toList(),
    );
  }
}
