import 'tokens_entity.dart';
import 'user_entity.dart';

/// Login response entity
/// Domain layer - Pure Dart
class LoginResponseEntity {
  const LoginResponseEntity({required this.tokens, required this.user});
  final TokensEntity tokens;
  final UserEntity user;
}
