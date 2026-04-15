class LocationSearchResultEntity {
  const LocationSearchResultEntity({
    this.placeId,
    required this.addressLine,
    required this.latitude,
    required this.longitude,
  });
  final int? placeId;
  final String addressLine;
  final double latitude;
  final double longitude;
}
