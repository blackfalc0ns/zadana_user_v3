// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reverse_address_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReverseAddressDto _$ReverseAddressDtoFromJson(Map<String, dynamic> json) =>
    ReverseAddressDto(
      city: json['city'] as String?,
      town: json['town'] as String?,
      village: json['village'] as String?,
      state: json['state'] as String?,
      county: json['county'] as String?,
      suburb: json['suburb'] as String?,
      road: json['road'] as String?,
    );

Map<String, dynamic> _$ReverseAddressDtoToJson(ReverseAddressDto instance) =>
    <String, dynamic>{
      'city': instance.city,
      'town': instance.town,
      'village': instance.village,
      'state': instance.state,
      'county': instance.county,
      'suburb': instance.suburb,
      'road': instance.road,
    };
