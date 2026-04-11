import 'package:json_annotation/json_annotation.dart';

part 'cart_summary_response_dto.g.dart';

@JsonSerializable()
class CartSummaryResponseDto {
  const CartSummaryResponseDto({
    required this.itemsCount,
    required this.totalQuantity,
  });

  final int itemsCount;
  final int totalQuantity;

  factory CartSummaryResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CartSummaryResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CartSummaryResponseDtoToJson(this);
}
