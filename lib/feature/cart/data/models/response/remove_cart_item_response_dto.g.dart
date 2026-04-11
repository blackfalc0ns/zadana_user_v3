// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_cart_item_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoveCartItemResponseDto _$RemoveCartItemResponseDtoFromJson(
  Map<String, dynamic> json,
) => RemoveCartItemResponseDto(
  message: json['message'] as String,
  summary: CartSummaryResponseDto.fromJson(
    json['summary'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$RemoveCartItemResponseDtoToJson(
  RemoveCartItemResponseDto instance,
) => <String, dynamic>{
  'message': instance.message,
  'summary': instance.summary,
};
