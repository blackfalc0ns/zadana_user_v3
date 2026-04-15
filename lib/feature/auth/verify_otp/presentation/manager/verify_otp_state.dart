import 'package:zadana_user_v3/core/network/failures.dart';
import '../../domain/entities/verify_otp_response_entity.dart';

/// State for verify OTP feature
/// Handles loading, success, error states
class VerifyOtpState {
  const VerifyOtpState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.verifyOtpResponse,
    this.failure,
  });
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final VerifyOtpResponseEntity? verifyOtpResponse;
  final Failure? failure;

  VerifyOtpState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    VerifyOtpResponseEntity? verifyOtpResponse,
    Failure? failure,
  }) {
    return VerifyOtpState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      verifyOtpResponse: verifyOtpResponse ?? this.verifyOtpResponse,
      failure: failure,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VerifyOtpState &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.isSuccess == isSuccess &&
        other.verifyOtpResponse == verifyOtpResponse &&
        other.failure == failure;
  }

  @override
  int get hashCode => Object.hash(
    isLoading,
    errorMessage,
    isSuccess,
    verifyOtpResponse,
    failure,
  );
}
