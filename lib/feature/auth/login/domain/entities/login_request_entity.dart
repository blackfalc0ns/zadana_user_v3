/// Login request entity
/// Domain layer - Pure Dart
class LoginRequestEntity {
  final String identifier;
  final String password;

  const LoginRequestEntity({
    required this.identifier,
    required this.password,
  });
}