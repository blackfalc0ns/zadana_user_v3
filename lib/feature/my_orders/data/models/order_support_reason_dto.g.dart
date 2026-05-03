// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_support_reason_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderSupportReasonDto _$OrderSupportReasonDtoFromJson(
  Map<String, dynamic> json,
) => OrderSupportReasonDto(
  code: json['code'] as String? ?? '',
  labelAr: json['label_ar'] as String? ?? '',
  labelEn: json['label_en'] as String? ?? '',
  requiresNote: json['requires_note'] as bool? ?? false,
);

Map<String, dynamic> _$OrderSupportReasonDtoToJson(
  OrderSupportReasonDto instance,
) => <String, dynamic>{
  'code': instance.code,
  'label_ar': instance.labelAr,
  'label_en': instance.labelEn,
  'requires_note': instance.requiresNote,
};
