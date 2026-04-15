abstract class DeliveryOtpEvent {}

class SendOtpEvent extends DeliveryOtpEvent {
  SendOtpEvent({required this.orderId, required this.phoneNumber});
  final String orderId;
  final String phoneNumber;
}

class VerifyOtpEvent extends DeliveryOtpEvent {
  VerifyOtpEvent({required this.orderId, required this.otpCode});
  final String orderId;
  final String otpCode;
}

class ResendOtpEvent extends DeliveryOtpEvent {
  ResendOtpEvent({required this.orderId});
  final String orderId;
}

class OtpTextChangedEvent extends DeliveryOtpEvent {
  OtpTextChangedEvent(this.otpCode);
  final String otpCode;
}
