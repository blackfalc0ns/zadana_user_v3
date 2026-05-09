import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/order_item_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_list_item_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_status.dart';

part 'order_list_item_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class OrderListItemDto {
  const OrderListItemDto({
    required this.id,
    required this.orderNumber,
    required this.createdAt,
    required this.totalPrice,
    required this.status,
    required this.itemsCount,
    required this.items,
  });

  factory OrderListItemDto.fromJson(Map<String, dynamic> json) {
    return OrderListItemDto(
      id: json['id']?.toString() ?? '',
      orderNumber:
          json['order_number']?.toString() ?? json['id']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0,
      status: json['status']?.toString() ?? '',
      itemsCount: (json['items_count'] as num?)?.toInt() ?? 0,
      items: _list(
        json['items'],
      ).map((item) => OrderItemDto.fromJson(_map(item))).toList(),
    );
  }

  final String id;
  final String orderNumber;
  final DateTime createdAt;
  final double totalPrice;
  final String status;
  final int itemsCount;
  final List<OrderItemDto> items;

  Map<String, dynamic> toJson() => _$OrderListItemDtoToJson(this);

  OrderListItemEntity toEntity() {
    return OrderListItemEntity(
      id: id,
      orderNumber: orderNumber,
      createdAt: createdAt,
      totalPrice: totalPrice,
      status: OrderStatus.fromApi(status),
      itemsCount: itemsCount,
      items: items.map((item) => item.toEntity()).toList(),
    );
  }

  static Map<String, dynamic> _map(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }

    return const <String, dynamic>{};
  }

  static List<dynamic> _list(dynamic value) {
    if (value is List) return value;
    return const <dynamic>[];
  }
}
