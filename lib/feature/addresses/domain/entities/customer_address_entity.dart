class CustomerAddressEntity {
  const CustomerAddressEntity({
    required this.id,
    required this.contactName,
    required this.contactPhone,
    required this.addressLine,
    required this.label,
    required this.buildingNo,
    required this.floorNo,
    required this.apartmentNo,
    required this.city,
    required this.area,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
  });

  final String id;
  final String contactName;
  final String contactPhone;
  final String addressLine;
  final String label;
  final String? buildingNo;
  final String? floorNo;
  final String? apartmentNo;
  final String city;
  final String area;
  final double? latitude;
  final double? longitude;
  final bool isDefault;
}
