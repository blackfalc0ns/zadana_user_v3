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

  factory OrderSupportReasonDto.fromJson(Map<String, dynamic> json) {
    // The API may return a single 'label' field (already localized)
    // instead of separate 'label_ar' / 'label_en' fields.
    final label = json['label']?.toString() ?? '';
    return OrderSupportReasonDto(
      code: json['code']?.toString() ?? '',
      labelAr: json['label_ar']?.toString() ?? label,
      labelEn: json['label_en']?.toString() ?? label,
      requiresNote: json['requires_note'] as bool? ?? false,
    );
  }

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
