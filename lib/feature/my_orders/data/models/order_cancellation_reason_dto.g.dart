// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_cancellation_reason_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderCancellationReasonDto _$OrderCancellationReasonDtoFromJson(
  Map<String, dynamic> json,
) => OrderCancellationReasonDto(
  code: json['code'] as String? ?? '',
  labelAr: json['label_ar'] as String? ?? '',
  labelEn: json['label_en'] as String? ?? '',
  requiresNote: json['requires_note'] as bool? ?? false,
);

Map<String, dynamic> _$OrderCancellationReasonDtoToJson(
  OrderCancellationReasonDto instance,
) => <String, dynamic>{
  'code': instance.code,
  'label_ar': instance.labelAr,
  'label_en': instance.labelEn,
  'requires_note': instance.requiresNote,
};
