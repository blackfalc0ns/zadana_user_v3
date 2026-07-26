import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import '../../domain/entities/verify_otp_request_entity.dart';
import '../../domain/usecase/resend_otp_usecase.dart';
import '../../domain/usecase/verify_otp_usecase.dart';
import 'verify_otp_event.dart';
import 'verify_otp_state.dart';

/// Verify OTP ViewModel
/// Handles verify OTP logic using intent/event pattern
@injectable
class VerifyOtpViewModel extends Cubit<VerifyOtpState> {
  VerifyOtpViewModel(
    this._verifyOtpUseCase,
    this._resendOtpUseCase,
    this._tokenService,
  ) : super(const VerifyOtpState());
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResendOtpUseCase _resendOtpUseCase;
  final TokenService _tokenService;

  /// Main intent handler
  /// Dispatches events to appropriate handlers
  void doIntent(VerifyOtpEvent event) {
    switch (event) {
      case VerifyOtpSubmitEvent():
        _verifyOtp(event.requestEntity);
      case ResendOtpCodeEvent():
        _resendOtp(event.identifier);
    }
  }

  /// Verify OTP
  Future<void> _verifyOtp(VerifyOtpRequestEntity requestEntity) async {
    emit(state.copyWith(isLoading: true));

    developer.log(
      'Verifying OTP for: ${requestEntity.identifier}',
      name: 'VerifyOtpViewModel',
    );

    final registrationToken = await _tokenService.getRegistrationToken();
    if (registrationToken == null || registrationToken.isEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage:
              'Registration session has expired. Please register again.',
          registrationSessionExpired: true,
        ),
      );
      return;
    }
    final result = await _verifyOtpUseCase.call(
      VerifyOtpRequestEntity(
        identifier: requestEntity.identifier,
        otpCode: requestEntity.otpCode,
        registrationToken: registrationToken,
      ),
    );

    switch (result) {
      case ApiSuccessResult():
        developer.log(
          'OTP verification successful, tokens saved',
          name: 'VerifyOtpViewModel',
        );

        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            verifyOtpResponse: result.data,
          ),
        );

      case ApiErrorResult():
        developer.log(
          'OTP verification failed: ${result.failure.errorMessage}',
          name: 'VerifyOtpViewModel',
        );

        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.failure.errorMessage,
            failure: result.failure,
          ),
        );
    }
  }

  /// Resend OTP
  Future<void> _resendOtp(String identifier) async {
    emit(state.copyWith(isResending: true, resendSuccess: false));

    final registrationToken = await _tokenService.getRegistrationToken();
    if (registrationToken == null || registrationToken.isEmpty) {
      emit(
        state.copyWith(
          isResending: false,
          errorMessage:
              'Registration session has expired. Please register again.',
          registrationSessionExpired: true,
        ),
      );
      return;
    }

    developer.log('Resending OTP for: $identifier', name: 'VerifyOtpViewModel');

    final result = await _resendOtpUseCase.call(identifier);

    switch (result) {
      case ApiSuccessResult():
        developer.log('OTP resent successfully', name: 'VerifyOtpViewModel');
        emit(state.copyWith(isResending: false, resendSuccess: true));

      case ApiErrorResult():
        developer.log(
          'Resend OTP failed: ${result.failure.errorMessage}',
          name: 'VerifyOtpViewModel',
        );
        emit(
          state.copyWith(
            isResending: false,
            resendSuccess: false,
            resendError: result.failure.errorMessage,
          ),
        );
    }
  }

  void clearFeedback() {
    emit(state.copyWith(isSuccess: false, resendSuccess: false));
  }
}
