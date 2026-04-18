// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_price_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderPriceSummaryDto _$OrderPriceSummaryDtoFromJson(
  Map<String, dynamic> json,
) => OrderPriceSummaryDto(
  subtotal: (json['subtotal'] as num).toDouble(),
  shippingCost: (json['shipping_cost'] as num).toDouble(),
  total: (json['total'] as num).toDouble(),
);

Map<String, dynamic> _$OrderPriceSummaryDtoToJson(
  OrderPriceSummaryDto instance,
) => <String, dynamic>{
  'subtotal': instance.subtotal,
  'shipping_cost': instance.shippingCost,
  'total': instance.total,
};
