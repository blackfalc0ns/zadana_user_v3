class UpdateProfileRequestEntity {
  const UpdateProfileRequestEntity({
    required this.fullName,
    required this.email,
    required this.phone,
  });
  final String fullName;
  final String email;
  final String phone;
}
