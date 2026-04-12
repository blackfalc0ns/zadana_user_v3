import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import '../../domain/entities/verify_otp_request_entity.dart';
import '../../domain/usecase/verify_otp_usecase.dart';
import 'verify_otp_event.dart';
import 'verify_otp_state.dart';

/// Verify OTP ViewModel
/// Handles verify OTP logic using intent/event pattern
@injectable
class VerifyOtpViewModel extends Cubit<VerifyOtpState> {
  final VerifyOtpUseCase _verifyOtpUseCase;

  VerifyOtpViewModel(
    this._verifyOtpUseCase,
  ) : super(const VerifyOtpState());

  /// Main intent handler
  /// Dispatches events to appropriate handlers
  void doIntent(VerifyOtpEvent event) {
    switch (event) {
      case VerifyOtpSubmitEvent():
        _verifyOtp(event.requestEntity);
    }
  }

  /// Verify OTP
  Future<void> _verifyOtp(
    VerifyOtpRequestEntity requestEntity,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
    ));

    developer.log(
      'Verifying OTP for: ${requestEntity.identifier}',
      name: 'VerifyOtpViewModel',
    );

    final result = await _verifyOtpUseCase.call(requestEntity);

    switch (result) {
      case ApiSuccessResult():
        developer.log(
          'OTP verification successful, tokens saved',
          name: 'VerifyOtpViewModel',
        );

        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          verifyOtpResponse: result.data,
        ));

      case ApiErrorResult():
        developer.log(
          'OTP verification failed: ${result.failure.errorMessage}',
          name: 'VerifyOtpViewModel',
        );

        emit(state.copyWith(
          isLoading: false,
          errorMessage: result.failure.code,
        ));
    }
  }
}
