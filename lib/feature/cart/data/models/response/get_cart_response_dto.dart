import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/cart_item_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/cart_summary_response_dto.dart';

part 'get_cart_response_dto.g.dart';

@JsonSerializable()
class GetCartResponseDto {
  const GetCartResponseDto({required this.items, required this.summary});

  final List<CartItemResponseDto> items;
  final CartSummaryResponseDto summary;

  factory GetCartResponseDto.fromJson(Map<String, dynamic> json) =>
      _$GetCartResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetCartResponseDtoToJson(this);
}
