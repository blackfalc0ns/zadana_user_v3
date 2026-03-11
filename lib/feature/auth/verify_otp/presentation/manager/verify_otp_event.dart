import '../../domain/entities/verify_otp_request_entity.dart';

/// Base event class for verify OTP feature
/// All verify OTP events extend this
sealed class VerifyOtpEvent {}

/// Event to submit verify OTP form
class VerifyOtpSubmitEvent extends VerifyOtpEvent {
  final VerifyOtpRequestEntity requestEntity;

  VerifyOtpSubmitEvent({
    required this.requestEntity,
  });
}
