import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_cancellation_reason_entity.dart';

part 'order_cancellation_reason_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderCancellationReasonDto {
  const OrderCancellationReasonDto({
    required this.code,
    required this.label,
    required this.labelAr,
    required this.labelEn,
    required this.requiresNote,
  });

  factory OrderCancellationReasonDto.fromJson(Map<String, dynamic> json) =>
      _$OrderCancellationReasonDtoFromJson(json);

  @JsonKey(defaultValue: '')
  final String code;
  @JsonKey(defaultValue: '')
  final String label;
  @JsonKey(defaultValue: '')
  final String labelAr;
  @JsonKey(defaultValue: '')
  final String labelEn;
  @JsonKey(defaultValue: false)
  final bool requiresNote;

  Map<String, dynamic> toJson() => _$OrderCancellationReasonDtoToJson(this);

  OrderCancellationReasonEntity toEntity() {
    final resolvedLabelAr = labelAr.isNotEmpty ? labelAr : label;
    final resolvedLabelEn = labelEn.isNotEmpty ? labelEn : label;
    return OrderCancellationReasonEntity(
      code: code,
      labelAr: resolvedLabelAr,
      labelEn: resolvedLabelEn,
      requiresNote: requiresNote,
    );
  }
}
