// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_vendors_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartVendorsResponseDto _$CartVendorsResponseDtoFromJson(
  Map<String, dynamic> json,
) => CartVendorsResponseDto(
  vendors: (json['vendors'] as List<dynamic>)
      .map((e) => CartVendorItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num?)?.toInt(),
  limit: (json['limit'] as num?)?.toInt(),
  offset: (json['offset'] as num?)?.toInt(),
  hasMore: json['hasMore'] as bool?,
);

Map<String, dynamic> _$CartVendorsResponseDtoToJson(
  CartVendorsResponseDto instance,
) => <String, dynamic>{
  'vendors': instance.vendors,
  'total': instance.total,
  'limit': instance.limit,
  'offset': instance.offset,
  'hasMore': instance.hasMore,
};
