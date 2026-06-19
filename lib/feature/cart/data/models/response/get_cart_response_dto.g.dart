// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_cart_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCartResponseDto _$GetCartResponseDtoFromJson(Map<String, dynamic> json) =>
    GetCartResponseDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItemResponseDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: CartSummaryResponseDto.fromJson(
        json['summary'] as Map<String, dynamic>,
      ),
      total: (json['total'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      perPage: (json['perPage'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GetCartResponseDtoToJson(GetCartResponseDto instance) =>
    <String, dynamic>{
      'items': instance.items,
      'summary': instance.summary,
      'total': instance.total,
      'page': instance.page,
      'perPage': instance.perPage,
    };
