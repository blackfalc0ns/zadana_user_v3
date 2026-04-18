// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_orders_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedOrdersResponseDto _$PaginatedOrdersResponseDtoFromJson(
  Map<String, dynamic> json,
) => PaginatedOrdersResponseDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderListItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  page: (json['page'] as num).toInt(),
  perPage: (json['per_page'] as num).toInt(),
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$PaginatedOrdersResponseDtoToJson(
  PaginatedOrdersResponseDto instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'page': instance.page,
  'per_page': instance.perPage,
  'total': instance.total,
};
