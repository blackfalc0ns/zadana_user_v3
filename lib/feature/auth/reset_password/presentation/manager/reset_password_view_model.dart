import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/domain/usecase/reset_password_usecase.dart';
import 'reset_password_event.dart';
import 'reset_password_state.dart';

/// ViewModel for reset password feature
/// Handles business logic using intent/event pattern
@injectable
class ResetPasswordViewModel extends Cubit<ResetPasswordState> {
  ResetPasswordViewModel(this._resetPasswordUseCase)
    : super(const ResetPasswordState());

  final ResetPasswordUseCase _resetPasswordUseCase;

  /// Main intent handler
  /// Dispatches events to appropriate handlers
  void doIntent(ResetPasswordEvent event) {
    switch (event) {
      case ResetPasswordSubmitEvent():
        _submitResetPassword(event);
    }
  }

  /// Submit reset password request
  Future<void> _submitResetPassword(ResetPasswordSubmitEvent event) async {
    emit(state.copyWith(isLoading: true));

    developer.log('Submitting reset password', name: 'ResetPasswordViewModel');

    final result = await _resetPasswordUseCase.call(event.requestEntity);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            responseEntity: result.data,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.failure.errorMessage,
            failure: result.failure,
          ),
        );
    }
  }

  void clearFeedback() {
    emit(state.copyWith(isSuccess: false));
  }
}
