import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/core/utils/localized_api_message.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/cart_item_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/cart_summary_response_dto.dart';

part 'add_cart_item_response_dto.g.dart';

@JsonSerializable()
class AddCartItemResponseDto {
  factory AddCartItemResponseDto.fromJson(Map<String, dynamic> json) =>
      AddCartItemResponseDto(
        message: resolveLocalizedApiMessage(json),
        item: CartItemResponseDto.fromJson(
          json['item'] as Map<String, dynamic>? ?? <String, dynamic>{},
        ),
        summary: CartSummaryResponseDto.fromJson(
          json['summary'] as Map<String, dynamic>? ?? <String, dynamic>{},
        ),
      );
  const AddCartItemResponseDto({
    required this.message,
    required this.item,
    required this.summary,
  });

  final String message;
  final CartItemResponseDto item;
  final CartSummaryResponseDto summary;

  Map<String, dynamic> toJson() => _$AddCartItemResponseDtoToJson(this);
}
