/// Profile response entity
/// Domain layer - Pure Dart
class ProfileResponseEntity {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;

  const ProfileResponseEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
  });
}
