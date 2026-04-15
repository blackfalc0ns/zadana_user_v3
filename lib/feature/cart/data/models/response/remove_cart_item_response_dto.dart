import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/cart_summary_response_dto.dart';

part 'remove_cart_item_response_dto.g.dart';

@JsonSerializable()
class RemoveCartItemResponseDto {
  factory RemoveCartItemResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RemoveCartItemResponseDtoFromJson(json);
  const RemoveCartItemResponseDto({
    required this.message,
    required this.summary,
  });

  final String message;
  final CartSummaryResponseDto summary;

  Map<String, dynamic> toJson() => _$RemoveCartItemResponseDtoToJson(this);
}
