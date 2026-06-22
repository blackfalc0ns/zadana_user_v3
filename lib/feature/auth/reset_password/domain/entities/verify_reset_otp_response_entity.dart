class VerifyResetOtpResponseEntity {
  VerifyResetOtpResponseEntity({
    required this.resetToken,
    this.message,
  });
  final String resetToken;
  final String? message;
}
