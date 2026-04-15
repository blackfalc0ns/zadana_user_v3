/// Tokens entity
/// Domain layer - Pure Dart
class TokensEntity {
  const TokensEntity({required this.accessToken, this.refreshToken});
  final String accessToken;
  final String? refreshToken;
}
