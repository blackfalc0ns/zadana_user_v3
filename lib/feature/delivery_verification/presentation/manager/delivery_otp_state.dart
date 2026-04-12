
class DeliveryOtpState {
  final bool isLoading;
  final bool isSuccess;
  final bool showSuccessDialog;
  final String? errorMessage;
  final int remainingAttempts;
  final bool canResend;
  final int resendTimer;

  const DeliveryOtpState({
    this.isLoading = false,
    this.isSuccess = false,
    this.showSuccessDialog = false,
    this.errorMessage,
    this.remainingAttempts = 3,
    this.canResend = false,
    this.resendTimer = 30,
  });

  DeliveryOtpState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? showSuccessDialog,
    String? errorMessage,
    int? remainingAttempts,
    bool? canResend,
    int? resendTimer,
  }) {
    return DeliveryOtpState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      showSuccessDialog: showSuccessDialog ?? this.showSuccessDialog,
      errorMessage: errorMessage ?? this.errorMessage,
      remainingAttempts: remainingAttempts ?? this.remainingAttempts,
      canResend: canResend ?? this.canResend,
      resendTimer: resendTimer ?? this.resendTimer,
    );
  }
}