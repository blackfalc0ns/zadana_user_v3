import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_price_summary_entity.dart';

part 'order_price_summary_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderPriceSummaryDto {
  const OrderPriceSummaryDto({
    required this.subtotal,
    required this.shippingCost,
    required this.total,
  });

  factory OrderPriceSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$OrderPriceSummaryDtoFromJson(json);

  final double subtotal;
  final double shippingCost;
  final double total;

  Map<String, dynamic> toJson() => _$OrderPriceSummaryDtoToJson(this);

  OrderPriceSummaryEntity toEntity() {
    return OrderPriceSummaryEntity(
      subtotal: subtotal,
      shippingCost: shippingCost,
      total: total,
    );
  }
}
