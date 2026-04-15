import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/cart/data/models/cart_vendor_item_dto.dart';

part 'cart_vendors_response_dto.g.dart';

@JsonSerializable()
class CartVendorsResponseDto {
  factory CartVendorsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CartVendorsResponseDtoFromJson(json);
  const CartVendorsResponseDto({required this.vendors});

  final List<CartVendorItemDto> vendors;

  Map<String, dynamic> toJson() => _$CartVendorsResponseDtoToJson(this);
}
