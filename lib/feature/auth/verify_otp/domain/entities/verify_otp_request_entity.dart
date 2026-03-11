/// Verify OTP request entity
/// Domain layer - Pure Dart
class VerifyOtpRequestEntity {
  final String identifier;
  final String otpCode;

  const VerifyOtpRequestEntity({
    required this.identifier,
    required this.otpCode,
  });
}
