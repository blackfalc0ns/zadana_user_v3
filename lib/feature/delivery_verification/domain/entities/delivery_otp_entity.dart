class DeliveryOtpEntity {
  final String orderId;
  final String phoneNumber;
  final String otpCode;

  DeliveryOtpEntity({
    required this.orderId,
    required this.phoneNumber,
    required this.otpCode,
  });
}