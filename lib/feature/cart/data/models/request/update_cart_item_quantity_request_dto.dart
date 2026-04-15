import 'package:json_annotation/json_annotation.dart';

part 'update_cart_item_quantity_request_dto.g.dart';

@JsonSerializable()
class UpdateCartItemQuantityRequestDto {
  factory UpdateCartItemQuantityRequestDto.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateCartItemQuantityRequestDtoFromJson(json);
  const UpdateCartItemQuantityRequestDto({required this.quantity});

  final int quantity;

  Map<String, dynamic> toJson() =>
      _$UpdateCartItemQuantityRequestDtoToJson(this);
}
