/// User entity
/// Domain layer - Pure Dart
class UserModelVerifyEntity {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;

  const UserModelVerifyEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
  });
}