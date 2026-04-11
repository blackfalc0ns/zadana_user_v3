// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_summary_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartSummaryResponseDto _$CartSummaryResponseDtoFromJson(
  Map<String, dynamic> json,
) => CartSummaryResponseDto(
  itemsCount: (json['itemsCount'] as num).toInt(),
  totalQuantity: (json['totalQuantity'] as num).toInt(),
);

Map<String, dynamic> _$CartSummaryResponseDtoToJson(
  CartSummaryResponseDto instance,
) => <String, dynamic>{
  'itemsCount': instance.itemsCount,
  'totalQuantity': instance.totalQuantity,
};
