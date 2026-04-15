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
  });

  final int itemsCount;
  final int totalQuantity;
  final double? subtotal;
  final double? discountAmount;
  final double? totalAmount;

  Map<String, dynamic> toJson() => _$CartSummaryResponseDtoToJson(this);
}
