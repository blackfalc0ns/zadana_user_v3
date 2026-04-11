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
);

Map<String, dynamic> _$CartVendorsResponseDtoToJson(
  CartVendorsResponseDto instance,
) => <String, dynamic>{'vendors': instance.vendors};
