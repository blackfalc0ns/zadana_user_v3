class ResetPasswordRequestEntity {
  final String identifier;
  final String otpCode;
  final String newPassword;

  ResetPasswordRequestEntity({
    required this.identifier,
    required this.otpCode,
    required this.newPassword,
  });
}
