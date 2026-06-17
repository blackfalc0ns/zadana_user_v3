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
  subtotal: (json['subtotal'] as num?)?.toDouble(),
  discountAmount: (json['discountAmount'] as num?)?.toDouble(),
  totalAmount: (json['totalAmount'] as num?)?.toDouble(),
  hasUnavailableItems: json['has_unavailable_items'] as bool?,
  unavailableItemsCount: (json['unavailable_items_count'] as num?)?.toInt(),
  canCheckout: json['can_checkout'] as bool?,
  checkoutBlockReason: json['checkout_block_reason'] as String?,
);

Map<String, dynamic> _$CartSummaryResponseDtoToJson(
  CartSummaryResponseDto instance,
) => <String, dynamic>{
  'itemsCount': instance.itemsCount,
  'totalQuantity': instance.totalQuantity,
  'subtotal': instance.subtotal,
  'discountAmount': instance.discountAmount,
  'totalAmount': instance.totalAmount,
  'has_unavailable_items': instance.hasUnavailableItems,
  'unavailable_items_count': instance.unavailableItemsCount,
  'can_checkout': instance.canCheckout,
  'checkout_block_reason': instance.checkoutBlockReason,
};
