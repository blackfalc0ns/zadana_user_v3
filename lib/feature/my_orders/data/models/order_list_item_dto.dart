import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/order_item_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_list_item_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_status.dart';

part 'order_list_item_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class OrderListItemDto {
  const OrderListItemDto({
    required this.id,
    required this.createdAt,
    required this.totalPrice,
    required this.status,
    required this.itemsCount,
    required this.items,
  });

  factory OrderListItemDto.fromJson(Map<String, dynamic> json) =>
      _$OrderListItemDtoFromJson(json);

  final String id;
  final DateTime createdAt;
  final double totalPrice;
  final String status;
  final int itemsCount;
  final List<OrderItemDto> items;

  Map<String, dynamic> toJson() => _$OrderListItemDtoToJson(this);

  OrderListItemEntity toEntity() {
    return OrderListItemEntity(
      id: id,
      createdAt: createdAt,
      totalPrice: totalPrice,
      status: OrderStatus.fromApi(status),
      itemsCount: itemsCount,
      items: items.map((item) => item.toEntity()).toList(),
    );
  }
}
