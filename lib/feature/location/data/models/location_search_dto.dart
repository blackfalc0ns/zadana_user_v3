import 'package:json_annotation/json_annotation.dart';

part 'location_search_dto.g.dart';

@JsonSerializable()
class LocationSearchDto {
  LocationSearchDto({this.placeId, this.displayName, this.lat, this.lon});

  factory LocationSearchDto.fromJson(Map<String, dynamic> json) =>
      _$LocationSearchDtoFromJson(json);
  @JsonKey(name: 'place_id')
  final int? placeId;

  @JsonKey(name: 'display_name')
  final String? displayName;

  final String? lat;
  final String? lon;

  Map<String, dynamic> toJson() => _$LocationSearchDtoToJson(this);
}
