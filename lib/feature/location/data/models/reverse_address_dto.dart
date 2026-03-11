import 'package:json_annotation/json_annotation.dart';

part 'reverse_address_dto.g.dart';

@JsonSerializable()
class ReverseAddressDto {
  final String? city;
  final String? town;
  final String? village;
  final String? state;
  final String? county;
  final String? suburb;
  final String? road;

  ReverseAddressDto({
    this.city,
    this.town,
    this.village,
    this.state,
    this.county,
    this.suburb,
    this.road,
  });

  factory ReverseAddressDto.fromJson(Map<String, dynamic> json) =>
      _$ReverseAddressDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReverseAddressDtoToJson(this);
}