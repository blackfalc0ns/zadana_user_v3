class AddCustomerAddressRequestDto {
  const AddCustomerAddressRequestDto({
    required this.contactName,
    required this.contactPhone,
    required this.addressLine,
    required this.label,
    required this.floorNo,
    required this.apartmentNo,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
    this.buildingNo,
    this.area,
  });

  final String contactName;
  final String contactPhone;
  final String addressLine;
  final String label;
  final String? buildingNo;
  final String floorNo;
  final String apartmentNo;
  final String city;
  final String? area;
  final double latitude;
  final double longitude;
  final bool isDefault;

  Map<String, dynamic> toJson() => {
    'contactName': contactName,
    'contactPhone': contactPhone,
    'addressLine': addressLine,
    'label': label,
    'buildingNo': buildingNo,
    'floorNo': floorNo,
    'apartmentNo': apartmentNo,
    'city': city,
    'area': area,
    'latitude': latitude,
    'longitude': longitude,
    'isDefault': isDefault,
  };
}
