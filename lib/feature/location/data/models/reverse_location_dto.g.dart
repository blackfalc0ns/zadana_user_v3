// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reverse_location_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReverseLocationDto _$ReverseLocationDtoFromJson(Map<String, dynamic> json) =>
    ReverseLocationDto(
      address: json['address'] == null
          ? null
          : ReverseAddressDto.fromJson(json['address'] as Map<String, dynamic>),
      displayName: json['display_name'] as String?,
      lat: json['lat'] as String?,
      lon: json['lon'] as String?,
    );

Map<String, dynamic> _$ReverseLocationDtoToJson(ReverseLocationDto instance) =>
    <String, dynamic>{
      'display_name': instance.displayName,
      'lat': instance.lat,
      'lon': instance.lon,
      'address': instance.address,
    };
