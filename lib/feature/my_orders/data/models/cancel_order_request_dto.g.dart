// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancel_order_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CancelOrderRequestDto _$CancelOrderRequestDtoFromJson(
  Map<String, dynamic> json,
) => CancelOrderRequestDto(
  reasonCode: json['reason_code'] as String,
  reason: json['reason'] as String,
  note: json['note'] as String,
);

Map<String, dynamic> _$CancelOrderRequestDtoToJson(
  CancelOrderRequestDto instance,
) => <String, dynamic>{
  'reason_code': instance.reasonCode,
  'reason': instance.reason,
  'note': instance.note,
};
