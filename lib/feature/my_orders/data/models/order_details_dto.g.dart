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
      canCancel: json['can_cancel'] as bool,
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
      'can_cancel': instance.canCancel,
      'items_count': instance.itemsCount,
      'summary': instance.summary.toJson(),
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
