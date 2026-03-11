import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/location/data/models/reverse_address_dto.dart';

part 'reverse_location_dto.g.dart';

@JsonSerializable()
class ReverseLocationDto {
  @JsonKey(name: 'display_name')
  final String? displayName;

  final String? lat;
  final String? lon;
final ReverseAddressDto? address;
  ReverseLocationDto({
    this.address,
    this.displayName,
    this.lat,
    this.lon,
  });

  factory ReverseLocationDto.fromJson(Map<String, dynamic> json) =>
      _$ReverseLocationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReverseLocationDtoToJson(this);
}