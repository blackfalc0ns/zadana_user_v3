// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_cart_item_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddCartItemResponseDto _$AddCartItemResponseDtoFromJson(
  Map<String, dynamic> json,
) => AddCartItemResponseDto(
  message: json['message'] as String,
  item: CartItemResponseDto.fromJson(json['item'] as Map<String, dynamic>),
  summary: CartSummaryResponseDto.fromJson(
    json['summary'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$AddCartItemResponseDtoToJson(
  AddCartItemResponseDto instance,
) => <String, dynamic>{
  'message': instance.message,
  'item': instance.item,
  'summary': instance.summary,
};
