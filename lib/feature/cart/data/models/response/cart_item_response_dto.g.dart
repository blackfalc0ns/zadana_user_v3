// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemResponseDto _$CartItemResponseDtoFromJson(Map<String, dynamic> json) =>
    CartItemResponseDto(
      id: json['id'] as String,
      productId: json['productId'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      unit: json['unit'] as String,
      quantity: (json['quantity'] as num).toInt(),
      vendorPrices: (json['vendorPrices'] as List<dynamic>)
          .map(
            (e) => VendorPriceResponseDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$CartItemResponseDtoToJson(
  CartItemResponseDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'productId': instance.productId,
  'name': instance.name,
  'imageUrl': instance.imageUrl,
  'unit': instance.unit,
  'quantity': instance.quantity,
  'vendorPrices': instance.vendorPrices,
};
