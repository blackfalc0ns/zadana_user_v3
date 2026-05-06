import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/order_item_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/order_price_summary_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/order_support_case_dtos.dart';
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
    this.activeCase,
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
  @JsonKey(fromJson: _activeCaseFromJson, toJson: _activeCaseToJson)
  final OrderSupportCaseSummaryDto? activeCase;

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
      activeCase: activeCase?.toEntity(),
    );
  }

  static OrderSupportCaseSummaryDto? _activeCaseFromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) return null;
    return OrderSupportCaseSummaryDto.fromJson(json);
  }

  static Map<String, dynamic>? _activeCaseToJson(
    OrderSupportCaseSummaryDto? value,
  ) {
    if (value == null) return null;
    return <String, dynamic>{
      'id': value.id,
      'type': value.type,
      'type_label': value.typeLabel,
      'status': value.status,
      'status_label': value.statusLabel,
      'queue': value.queue,
      'queue_label': value.queueLabel,
      'priority': value.priority,
      'priority_label': value.priorityLabel,
      'reason_code': value.reasonCode,
      'reason_label': value.reasonLabel,
      'message': value.message,
      'created_at': value.createdAt?.toIso8601String(),
      'updated_at': value.updatedAt?.toIso8601String(),
    };
  }
}
