import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_reason_entity.dart';

part 'order_support_reason_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderSupportReasonDto {
  const OrderSupportReasonDto({
    required this.code,
    required this.labelAr,
    required this.labelEn,
    required this.requiresNote,
  });

  factory OrderSupportReasonDto.fromJson(Map<String, dynamic> json) =>
      _$OrderSupportReasonDtoFromJson(json);

  @JsonKey(defaultValue: '')
  final String code;
  @JsonKey(defaultValue: '')
  final String labelAr;
  @JsonKey(defaultValue: '')
  final String labelEn;
  @JsonKey(defaultValue: false)
  final bool requiresNote;

  Map<String, dynamic> toJson() => _$OrderSupportReasonDtoToJson(this);

  OrderSupportReasonEntity toEntity() {
    return OrderSupportReasonEntity(
      code: code,
      labelAr: labelAr,
      labelEn: labelEn,
      requiresNote: requiresNote,
    );
  }
}
