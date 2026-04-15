/// Verify OTP request entity
/// Domain layer - Pure Dart
class VerifyOtpRequestEntity {
  const VerifyOtpRequestEntity({
    required this.identifier,
    required this.otpCode,
  });
  final String identifier;
  final String otpCode;
}
