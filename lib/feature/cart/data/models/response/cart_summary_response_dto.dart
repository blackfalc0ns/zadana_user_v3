import 'package:json_annotation/json_annotation.dart';

part 'cart_summary_response_dto.g.dart';

@JsonSerializable()
class CartSummaryResponseDto {
  factory CartSummaryResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CartSummaryResponseDtoFromJson(json);
  const CartSummaryResponseDto({
    required this.itemsCount,
    required this.totalQuantity,
    this.subtotal,
    this.discountAmount,
    this.totalAmount,
    this.hasUnavailableItems,
    this.unavailableItemsCount,
    this.canCheckout,
    this.checkoutBlockReason,
  });

  final int itemsCount;
  final int totalQuantity;
  final double? subtotal;
  final double? discountAmount;
  final double? totalAmount;
  @JsonKey(name: 'has_unavailable_items')
  final bool? hasUnavailableItems;
  @JsonKey(name: 'unavailable_items_count')
  final int? unavailableItemsCount;
  @JsonKey(name: 'can_checkout')
  final bool? canCheckout;
  @JsonKey(name: 'checkout_block_reason')
  final String? checkoutBlockReason;

  Map<String, dynamic> toJson() => _$CartSummaryResponseDtoToJson(this);
}
