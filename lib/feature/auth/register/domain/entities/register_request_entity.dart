class RegisterRequestEntity {
   final String fullName;
  final String email;
  final String phone;
  final String password;
  final String addressLine;
  final String label;
  final String buildingNo;
  final String floorNo;
  final String apartmentNo;
  final String city;
  final String area;
  final double latitude;
  final double longitude;

  RegisterRequestEntity({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.addressLine,
    required this.label,
    required this.buildingNo,
    required this.floorNo,
    required this.apartmentNo,
    required this.city,
    required this.area,
    required this.latitude,
    required this.longitude,
  });
}
