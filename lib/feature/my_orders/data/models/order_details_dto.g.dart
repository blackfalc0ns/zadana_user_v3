// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailsDto _$OrderDetailsDtoFromJson(Map<String, dynamic> json) =>
    OrderDetailsDto(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'] as String,
      paymentStatus: json['payment_status'] as String,
      paymentMethod: json['payment_method'] as String,
      canCancel: json['can_cancel'] as bool,
      canRetryPayment: json['can_retry_payment'] as bool? ?? false,
      canDelete: json['can_delete'] as bool,
      itemsCount: (json['items_count'] as num).toInt(),
      summary: OrderPriceSummaryDto.fromJson(
        json['summary'] as Map<String, dynamic>,
      ),
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderDetailsDtoToJson(OrderDetailsDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'total_price': instance.totalPrice,
      'status': instance.status,
      'payment_status': instance.paymentStatus,
      'payment_method': instance.paymentMethod,
      'can_cancel': instance.canCancel,
      'can_retry_payment': instance.canRetryPayment,
      'can_delete': instance.canDelete,
      'items_count': instance.itemsCount,
      'summary': instance.summary.toJson(),
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
