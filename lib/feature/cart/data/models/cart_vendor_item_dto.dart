import 'package:json_annotation/json_annotation.dart';

part 'cart_vendor_item_dto.g.dart';

@JsonSerializable()
class CartVendorItemDto {
  factory CartVendorItemDto.fromJson(Map<String, dynamic> json) =>
      _$CartVendorItemDtoFromJson(json);
  const CartVendorItemDto({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.productsCount,
  });

  final String id;
  final String name;
  final String? logoUrl;
  final int productsCount;

  Map<String, dynamic> toJson() => _$CartVendorItemDtoToJson(this);
}
