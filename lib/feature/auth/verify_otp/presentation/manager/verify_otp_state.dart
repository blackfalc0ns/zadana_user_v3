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
    this.isResending = false,
    this.resendSuccess = false,
    this.resendError,
  });
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final VerifyOtpResponseEntity? verifyOtpResponse;
  final Failure? failure;
  final bool isResending;
  final bool resendSuccess;
  final String? resendError;

  VerifyOtpState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    VerifyOtpResponseEntity? verifyOtpResponse,
    Failure? failure,
    bool? isResending,
    bool? resendSuccess,
    String? resendError,
  }) {
    return VerifyOtpState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      verifyOtpResponse: verifyOtpResponse ?? this.verifyOtpResponse,
      failure: failure,
      isResending: isResending ?? this.isResending,
      resendSuccess: resendSuccess ?? this.resendSuccess,
      resendError: resendError,
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
        other.failure == failure &&
        other.isResending == isResending &&
        other.resendSuccess == resendSuccess &&
        other.resendError == resendError;
  }

  @override
  int get hashCode => Object.hash(
    isLoading,
    errorMessage,
    isSuccess,
    verifyOtpResponse,
    failure,
    isResending,
    resendSuccess,
    resendError,
  );
}
