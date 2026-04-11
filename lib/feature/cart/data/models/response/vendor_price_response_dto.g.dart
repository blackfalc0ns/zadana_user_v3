// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_price_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorPriceResponseDto _$VendorPriceResponseDtoFromJson(
  Map<String, dynamic> json,
) => VendorPriceResponseDto(
  id: json['id'] as String,
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
  oldPrice: (json['oldPrice'] as num?)?.toDouble(),
  isDiscounted: json['isDiscounted'] as bool,
);

Map<String, dynamic> _$VendorPriceResponseDtoToJson(
  VendorPriceResponseDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'price': instance.price,
  'oldPrice': instance.oldPrice,
  'isDiscounted': instance.isDiscounted,
};
