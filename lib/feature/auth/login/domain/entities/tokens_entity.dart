/// Tokens entity
/// Domain layer - Pure Dart
class TokensEntity {
  final String accessToken;
  final String refreshToken;

  const TokensEntity({
    required this.accessToken,
    required this.refreshToken,
  });
}