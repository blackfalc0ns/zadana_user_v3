import 'package:json_annotation/json_annotation.dart';

part 'add_cart_item_request_dto.g.dart';

@JsonSerializable()
class AddCartItemRequestDto {
  const AddCartItemRequestDto({
    required this.productId,
    required this.quantity,
  });

  final String productId;
  final int quantity;

  factory AddCartItemRequestDto.fromJson(Map<String, dynamic> json) =>
      _$AddCartItemRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddCartItemRequestDtoToJson(this);
}
