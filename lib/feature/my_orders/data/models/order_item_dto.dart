import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_item_entity.dart';

part 'order_item_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderItemDto {
  const OrderItemDto({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory OrderItemDto.fromJson(Map<String, dynamic> json) {
    return OrderItemDto(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
    );
  }

  final String id;
  final String name;
  final int quantity;
  final double price;

  Map<String, dynamic> toJson() => _$OrderItemDtoToJson(this);

  OrderItemEntity toEntity() {
    return OrderItemEntity(
      id: id,
      name: name,
      quantity: quantity,
      price: price,
    );
  }
}
