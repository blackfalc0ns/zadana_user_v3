// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_search_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationSearchDto _$LocationSearchDtoFromJson(Map<String, dynamic> json) =>
    LocationSearchDto(
      placeId: (json['place_id'] as num?)?.toInt(),
      displayName: json['display_name'] as String?,
      lat: json['lat'] as String?,
      lon: json['lon'] as String?,
    );

Map<String, dynamic> _$LocationSearchDtoToJson(LocationSearchDto instance) =>
    <String, dynamic>{
      'place_id': instance.placeId,
      'display_name': instance.displayName,
      'lat': instance.lat,
      'lon': instance.lon,
    };
