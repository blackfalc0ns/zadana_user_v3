import 'package:latlong2/latlong.dart' as ll;

/// Location selection model
class LocationModel {
  final double latitude;
  final double longitude;
  final String address;
  final DateTime timestamp;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.timestamp,
  });

  /// Create LocationModel from coordinates and address
  factory LocationModel.fromCoordinates({
    required double latitude,
    required double longitude,
    required String address,
  }) {
    return LocationModel(
      latitude: latitude,
      longitude: longitude,
      address: address,
      timestamp: DateTime.now(),
    );
  }

  /// Create LocationModel from LatLng
  factory LocationModel.fromLatLng({
    required ll.LatLng coordinates,
    required String address,
  }) {
    return LocationModel(
      latitude: coordinates.latitude,
      longitude: coordinates.longitude,
      address: address,
      timestamp: DateTime.now(),
    );
  }

  /// Get LatLng coordinates
  ll.LatLng get coordinates => ll.LatLng(latitude, longitude);

  /// Copy with new values
  LocationModel copyWith({
    double? latitude,
    double? longitude,
    String? address,
    DateTime? timestamp,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationModel &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.address == address;
  }

  @override
  int get hashCode {
    return latitude.hashCode ^
        longitude.hashCode ^
        address.hashCode;
  }

  @override
  String toString() {
    return 'LocationModel(latitude: $latitude, longitude: $longitude, address: $address, timestamp: $timestamp)';
  }
}
