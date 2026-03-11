// import 'package:json_annotation/json_annotation.dart';
// import '../models/location_model.dart';

// part 'location_response_dto.g.dart';

// /// Location response DTO
// /// Data layer - DTO
// @JsonSerializable()
// class LocationResponseDto {
//   final double latitude;
//   final double longitude;
//   final String address;

//   const LocationResponseDto({
//     required this.latitude,
//     required this.longitude,
//     required this.address,
//   });

//   factory LocationResponseDto.fromJson(Map<String, dynamic> json) =>
//       _$LocationResponseDtoFromJson(json);

//   Map<String, dynamic> toJson() => _$LocationResponseDtoToJson(this);

//   LocationModel toModel() {
//     return LocationModel.fromCoordinates(
//       latitude: latitude,
//       longitude: longitude,
//       address: address,
//     );
//   }
// }
