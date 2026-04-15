class DeliveryOtpEntity {
  DeliveryOtpEntity({
    required this.orderId,
    required this.phoneNumber,
    required this.otpCode,
  });
  final String orderId;
  final String phoneNumber;
  final String otpCode;
}
