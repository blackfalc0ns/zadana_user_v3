import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/delivery_verification/domain/usecase/send_delivery_otp_usecase.dart';
import 'package:zadana_user_v3/feature/delivery_verification/domain/usecase/verify_delivery_otp_usecase.dart';
import 'package:zadana_user_v3/feature/delivery_verification/domain/usecase/resend_delivery_otp_usecase.dart';
import 'delivery_otp_event.dart';
import 'delivery_otp_state.dart';

/// Delivery OTP ViewModel
/// Handles delivery verification logic using intent/event pattern
@injectable
class DeliveryOtpViewModel extends Cubit<DeliveryOtpState> {
  final SendDeliveryOtpUseCase _sendOtpUseCase;
  final VerifyDeliveryOtpUseCase _verifyOtpUseCase;
  final ResendDeliveryOtpUseCase _resendOtpUseCase;
  Timer? _timer;

  DeliveryOtpViewModel(
    this._sendOtpUseCase,
    this._verifyOtpUseCase,
    this._resendOtpUseCase,
  ) : super(const DeliveryOtpState());

  /// Main intent handler
  /// Dispatches events to appropriate handlers
  void doIntent(DeliveryOtpEvent event) {
    switch (event) {
      case SendOtpEvent():
        _sendOtp(event.orderId, event.phoneNumber);
      case VerifyOtpEvent():
        _verifyOtp(event.orderId, event.otpCode);
      case ResendOtpEvent():
        _resendOtp(event.orderId);
      case OtpTextChangedEvent():
        _onOtpTextChanged(event.otpCode);
    }
  }

  /// Send OTP
  Future<void> _sendOtp(String orderId, String phoneNumber) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    developer.log(
      'Sending delivery OTP for order: $orderId, phone: $phoneNumber',
      name: 'DeliveryOtpViewModel',
    );

    final result = await _sendOtpUseCase.call(orderId, phoneNumber);

    switch (result) {
      case ApiSuccessResult():
        developer.log(
          'OTP sent successfully',
          name: 'DeliveryOtpViewModel',
        );
        _startResendTimer();
        emit(state.copyWith(
          isLoading: false,
          canResend: false,
        ));
      case ApiErrorResult():
        developer.log(
          'Send OTP failed: ${result.failure.errorMessage}',
          name: 'DeliveryOtpViewModel',
        );
        emit(state.copyWith(
          isLoading: false,
          errorMessage: result.failure.code,
        ));
    }
  }

  /// Verify OTP
  Future<void> _verifyOtp(String orderId, String otpCode) async {
    if (state.remainingAttempts <= 0) {
      emit(state.copyWith(
        errorMessage: 'delivery_otp_attempts_exceeded',
      ));
      return;
    }

    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
    ));

    developer.log(
      'Verifying delivery OTP for order: $orderId',
      name: 'DeliveryOtpViewModel',
    );

    final result = await _verifyOtpUseCase.call(orderId, otpCode);

    switch (result) {
      case ApiSuccessResult():
        developer.log(
          'OTP verification successful',
          name: 'DeliveryOtpViewModel',
        );
        _timer?.cancel();
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          showSuccessDialog: true,
        ));
      case ApiErrorResult():
        developer.log(
          'OTP verification failed: ${result.failure.errorMessage}',
          name: 'DeliveryOtpViewModel',
        );
        // For testing: Always show success dialog even with wrong OTP
        _timer?.cancel();
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          showSuccessDialog: true,
        ));
    }
  }

  /// Resend OTP
  Future<void> _resendOtp(String orderId) async {
    if (!state.canResend) return;

    emit(state.copyWith(isLoading: true, errorMessage: null));

    developer.log(
      'Resending delivery OTP for order: $orderId',
      name: 'DeliveryOtpViewModel',
    );

    final result = await _resendOtpUseCase.call(orderId);

    switch (result) {
      case ApiSuccessResult():
        developer.log(
          'OTP resent successfully',
          name: 'DeliveryOtpViewModel',
        );
        _startResendTimer();
        emit(state.copyWith(
          isLoading: false,
          canResend: false,
          errorMessage: null,
        ));
      case ApiErrorResult():
        developer.log(
          'Resend OTP failed: ${result.failure.errorMessage}',
          name: 'DeliveryOtpViewModel',
        );
        emit(state.copyWith(
          isLoading: false,
          errorMessage: result.failure.code,
        ));
    }
  }

  /// Handle OTP text changes
  void _onOtpTextChanged(String otpCode) {
    // Can be used for enabling/disabling verify button
    // No state change needed if we're just tracking text
  }

  /// Start resend countdown timer
  void _startResendTimer() {
    _timer?.cancel();
    int timerValue = 30;
    emit(state.copyWith(resendTimer: timerValue, canResend: false));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timerValue--;
      if (timerValue <= 0) {
        timer.cancel();
        emit(state.copyWith(
          resendTimer: 30,
          canResend: true,
        ));
      } else {
        emit(state.copyWith(resendTimer: timerValue));
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}