/// Login request entity
/// Domain layer - Pure Dart
class LoginRequestEntity {
  const LoginRequestEntity({required this.identifier, required this.password});
  final String identifier;
  final String password;
}
