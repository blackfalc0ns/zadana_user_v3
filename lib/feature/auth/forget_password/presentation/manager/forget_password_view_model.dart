import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/domain/usecase/forget_password_usecase.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/presentation/manager/forget_password_event.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/presentation/manager/forget_password_state.dart';

/// ViewModel for forgot password feature
/// Handles business logic using intent/event pattern
@injectable
class ForgetPasswordViewModel extends Cubit<ForgetPasswordState> {
  ForgetPasswordViewModel(
    this._forgetPasswordUseCase,
  ) : super(const ForgetPasswordState());

  final ForgetPasswordUseCase _forgetPasswordUseCase;

  /// Main intent handler
  /// Dispatches events to appropriate handlers
  void doIntent(ForgetPasswordEvent event) {
    switch (event) {
      case ForgetPasswordSubmitEvent():
        _submitForgotPassword(event);
    }
  }

  /// Submit forgot password request
  Future<void> _submitForgotPassword(
    ForgetPasswordSubmitEvent event,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
    ));

    developer.log(
      'Submitting forgot password: ${event.requestEntity.identifier}',
      name: 'ForgotPasswordViewModel',
    );

    final result = await _forgetPasswordUseCase.call(
      event.requestEntity,
    );

    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          responseEntity: result.data,
        ));
      case ApiErrorResult():
        emit(state.copyWith(
          isLoading: false,
          errorMessage: result.failure.code,
        ));
    }
  }
}
