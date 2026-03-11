class RegisterResponseEntity {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final bool isVerified;
  final String message;

  RegisterResponseEntity({
    required this.message,
    required this.isVerified,
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
  });
}
