// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancel_order_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CancelOrderResponseDto _$CancelOrderResponseDtoFromJson(
  Map<String, dynamic> json,
) => CancelOrderResponseDto(
  message: json['message'] as String? ?? '',
  order: CancelledOrderDto.fromJson(json['order'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CancelOrderResponseDtoToJson(
  CancelOrderResponseDto instance,
) => <String, dynamic>{
  'message': instance.message,
  'order': instance.order.toJson(),
};

CancelledOrderDto _$CancelledOrderDtoFromJson(Map<String, dynamic> json) =>
    CancelledOrderDto(
      id: json['id'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );

Map<String, dynamic> _$CancelledOrderDtoToJson(CancelledOrderDto instance) =>
    <String, dynamic>{'id': instance.id, 'status': instance.status};
