// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_order_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteOrderResponseDto _$DeleteOrderResponseDtoFromJson(
  Map<String, dynamic> json,
) => DeleteOrderResponseDto(
  message: json['message'] as String? ?? '',
  orderId: json['order_id'] as String? ?? '',
  deleted: json['deleted'] as bool? ?? false,
);

Map<String, dynamic> _$DeleteOrderResponseDtoToJson(
  DeleteOrderResponseDto instance,
) => <String, dynamic>{
  'message': instance.message,
  'order_id': instance.orderId,
  'deleted': instance.deleted,
};
