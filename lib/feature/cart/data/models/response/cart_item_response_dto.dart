import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/vendor_price_response_dto.dart';

part 'cart_item_response_dto.g.dart';

@JsonSerializable()
class CartItemResponseDto {
  factory CartItemResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CartItemResponseDtoFromJson(json);
  const CartItemResponseDto({
    required this.id,
    required this.productId,
    required this.name,
    this.imageUrl,
    required this.unit,
    required this.quantity,
    required this.vendorPrices,
  });

  final String id;
  final String productId;
  final String name;
  final String? imageUrl;
  final String unit;
  final int quantity;
  final List<VendorPriceResponseDto> vendorPrices;

  Map<String, dynamic> toJson() => _$CartItemResponseDtoToJson(this);
}
