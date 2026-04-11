// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_vendor_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartVendorItemDto _$CartVendorItemDtoFromJson(Map<String, dynamic> json) =>
    CartVendorItemDto(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String?,
      productsCount: (json['productsCount'] as num).toInt(),
    );

Map<String, dynamic> _$CartVendorItemDtoToJson(CartVendorItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logoUrl': instance.logoUrl,
      'productsCount': instance.productsCount,
    };
