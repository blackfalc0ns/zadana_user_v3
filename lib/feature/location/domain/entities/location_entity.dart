class LocationEntity {
  final String addressLine;
  final String city;
  final String area;
  final double latitude;
  final double longitude;
  final String buildingNo;
  final String floorNo;
  final String apartmentNo;
  final String label;

  const LocationEntity({
    required this.addressLine,
    required this.city,
    required this.area,
    required this.latitude,
    required this.longitude,
    this.buildingNo = '',
    this.floorNo = '',
    this.apartmentNo = '',
    this.label = '',
  });
}