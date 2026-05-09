// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_list_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderListItemDto _$OrderListItemDtoFromJson(Map<String, dynamic> json) =>
    OrderListItemDto(
      id: json['id'] as String,
      orderNumber: json['order_number'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'] as String,
      itemsCount: (json['items_count'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderListItemDtoToJson(OrderListItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'created_at': instance.createdAt.toIso8601String(),
      'total_price': instance.totalPrice,
      'status': instance.status,
      'items_count': instance.itemsCount,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
