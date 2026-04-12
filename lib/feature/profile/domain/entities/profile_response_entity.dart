/// Profile response entity
/// Domain layer - Pure Dart
class ProfileResponseEntity {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final int favoritesCount;

  const ProfileResponseEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.favoritesCount,
  });
}
