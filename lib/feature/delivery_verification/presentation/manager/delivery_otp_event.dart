
abstract class DeliveryOtpEvent {}

class SendOtpEvent extends DeliveryOtpEvent {
  final String orderId;
  final String phoneNumber;

  SendOtpEvent({required this.orderId, required this.phoneNumber});
}

class VerifyOtpEvent extends DeliveryOtpEvent {
  final String orderId;
  final String otpCode;

  VerifyOtpEvent({required this.orderId, required this.otpCode});
}

class ResendOtpEvent extends DeliveryOtpEvent {
  final String orderId;

  ResendOtpEvent({required this.orderId});
}

class OtpTextChangedEvent extends DeliveryOtpEvent {
  final String otpCode;

  OtpTextChangedEvent(this.otpCode);
}