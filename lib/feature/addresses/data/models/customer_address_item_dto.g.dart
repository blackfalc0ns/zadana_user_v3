// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_address_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerAddressItemDto _$CustomerAddressItemDtoFromJson(
  Map<String, dynamic> json,
) => CustomerAddressItemDto(
  id: json['id'] as String,
  contactName: json['contactName'] as String,
  contactPhone: json['contactPhone'] as String,
  addressLine: json['addressLine'] as String,
  label: json['label'] as String,
  buildingNo: json['buildingNo'] as String?,
  floorNo: json['floorNo'] as String?,
  apartmentNo: json['apartmentNo'] as String?,
  city: json['city'] as String,
  area: json['area'] as String? ?? '',
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  isDefault: json['isDefault'] as bool,
);

Map<String, dynamic> _$CustomerAddressItemDtoToJson(
  CustomerAddressItemDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'contactName': instance.contactName,
  'contactPhone': instance.contactPhone,
  'addressLine': instance.addressLine,
  'label': instance.label,
  'buildingNo': instance.buildingNo,
  'floorNo': instance.floorNo,
  'apartmentNo': instance.apartmentNo,
  'city': instance.city,
  'area': instance.area,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'isDefault': instance.isDefault,
};
