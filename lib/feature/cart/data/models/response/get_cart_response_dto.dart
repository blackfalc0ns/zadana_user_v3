import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/cart_item_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/cart_summary_response_dto.dart';

part 'get_cart_response_dto.g.dart';

@JsonSerializable()
class GetCartResponseDto {
  factory GetCartResponseDto.fromJson(Map<String, dynamic> json) =>
      _$GetCartResponseDtoFromJson(json);
  const GetCartResponseDto({
    required this.items,
    required this.summary,
    this.total,
    this.limit,
    this.offset,
    this.hasMore,
  });

  final List<CartItemResponseDto> items;
  final CartSummaryResponseDto summary;
  final int? total;
  final int? limit;
  final int? offset;
  final bool? hasMore;

  Map<String, dynamic> toJson() => _$GetCartResponseDtoToJson(this);
}
