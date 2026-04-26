import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/order_item_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/order_price_summary_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_details_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_status.dart';

part 'order_details_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class OrderDetailsDto {
  const OrderDetailsDto({
    required this.id,
    required this.createdAt,
    required this.totalPrice,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.canCancel,
    this.canRetryPayment = false,
    required this.canDelete,
    required this.itemsCount,
    required this.summary,
    required this.items,
  });

  factory OrderDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsDtoFromJson(json);

  final String id;
  final DateTime createdAt;
  final double totalPrice;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final bool canCancel;
  @JsonKey(defaultValue: false)
  final bool canRetryPayment;
  final bool canDelete;
  final int itemsCount;
  final OrderPriceSummaryDto summary;
  final List<OrderItemDto> items;

  Map<String, dynamic> toJson() => _$OrderDetailsDtoToJson(this);

  OrderDetailsEntity toEntity() {
    return OrderDetailsEntity(
      id: id,
      createdAt: createdAt,
      totalPrice: totalPrice,
      status: OrderStatus.fromApi(status),
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
      canCancel: canCancel,
      canRetryPayment: canRetryPayment,
      canDelete: canDelete,
      itemsCount: itemsCount,
      summary: summary.toEntity(),
      items: items.map((item) => item.toEntity()).toList(),
    );
  }
}
