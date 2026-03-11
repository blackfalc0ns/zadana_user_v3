// import 'package:latlong2/latlong.dart' as ll;

// class LocationSearchResult {
//   final String id;
//   final String name;
//   final String address;
//   final ll.LatLng coordinates;
//   final String? placeId;

//   LocationSearchResult({
//     required this.id,
//     required this.name,
//     required this.address,
//     required this.coordinates,
//     this.placeId,
//   });

//   factory LocationSearchResult.fromMap(Map<String, dynamic> map) {
//     return LocationSearchResult(
//       id: map['id']?.toString() ?? '',
//       name: map['name']?.toString() ?? '',
//       address: map['address']?.toString() ?? '',
//       coordinates: ll.LatLng(
//         map['latitude'] as double? ?? 0.0,
//         map['longitude'] as double? ?? 0.0,
//       ),
//       placeId: map['place_id']?.toString(),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'address': address,
//       'latitude': coordinates.latitude,
//       'longitude': coordinates.longitude,
//       'place_id': placeId,
//     };
//   }
// }
