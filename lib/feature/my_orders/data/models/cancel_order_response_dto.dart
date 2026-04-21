import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/cancel_order_response_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_status.dart';

part 'cancel_order_response_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CancelOrderResponseDto {
  const CancelOrderResponseDto({required this.message, required this.order});

  factory CancelOrderResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CancelOrderResponseDtoFromJson(json);

  @JsonKey(defaultValue: '')
  final String message;
  final CancelledOrderDto order;

  Map<String, dynamic> toJson() => _$CancelOrderResponseDtoToJson(this);

  CancelOrderResponseEntity toEntity() {
    return CancelOrderResponseEntity(message: message, order: order.toEntity());
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CancelledOrderDto {
  const CancelledOrderDto({required this.id, required this.status});

  factory CancelledOrderDto.fromJson(Map<String, dynamic> json) =>
      _$CancelledOrderDtoFromJson(json);

  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String status;

  Map<String, dynamic> toJson() => _$CancelledOrderDtoToJson(this);

  CancelledOrderEntity toEntity() {
    return CancelledOrderEntity(id: id, status: OrderStatus.fromApi(status));
  }
}
