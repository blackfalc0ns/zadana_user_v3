// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_cart_item_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddCartItemRequestDto _$AddCartItemRequestDtoFromJson(
  Map<String, dynamic> json,
) => AddCartItemRequestDto(
  productId: json['productId'] as String,
  quantity: (json['quantity'] as num).toInt(),
);

Map<String, dynamic> _$AddCartItemRequestDtoToJson(
  AddCartItemRequestDto instance,
) => <String, dynamic>{
  'productId': instance.productId,
  'quantity': instance.quantity,
};
