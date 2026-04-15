import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/entities/register_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/usecase/register_usecase.dart';
import 'register_event.dart';
import 'register_state.dart';

/// Single ViewModel for register feature
/// Handles both UI state and business logic
/// Uses intent/event pattern
@injectable
class RegisterViewModel extends Cubit<RegisterState> {
  RegisterViewModel(this._registerUseCase) : super(const RegisterState());
  final RegisterUseCase _registerUseCase;

  void doIntent(RegisterEvent event) {
    switch (event) {
      case SwitchToSignUpEvent():
        _switchToSignUp();
      case SwitchToLoginEvent():
        _switchToLogin();
    }
  }

  /// Switch to signup tab
  void _switchToSignUp() {
    if (!state.isSignUp) {
      emit(state.copyWith(isSignUp: true, isSuccess: false));
    }
  }

  /// Switch to login tab
  void _switchToLogin() {
    if (state.isSignUp) {
      emit(state.copyWith(isSignUp: false, isSuccess: false));
    }
  }

  Future<void> register(RegisterRequestEntity requestEntity) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));

    developer.log(
      'Registering user: ${requestEntity.fullName}',
      name: 'RegisterViewModel',
    );

    final result = await _registerUseCase.call(requestEntity);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            registerResponseEntity: result.data,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
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
