import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/cancel_order_request_entity.dart';

part 'cancel_order_request_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CancelOrderRequestDto {
  const CancelOrderRequestDto({
    required this.reasonCode,
    required this.reason,
    required this.note,
  });

  factory CancelOrderRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CancelOrderRequestDtoFromJson(json);

  factory CancelOrderRequestDto.fromEntity(CancelOrderRequestEntity entity) {
    return CancelOrderRequestDto(
      reasonCode: entity.reasonCode,
      reason: entity.reason,
      note: entity.note,
    );
  }

  final String reasonCode;
  final String reason;
  final String note;

  Map<String, dynamic> toJson() => _$CancelOrderRequestDtoToJson(this);
}
