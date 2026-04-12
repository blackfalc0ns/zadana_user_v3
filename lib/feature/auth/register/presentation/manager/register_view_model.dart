import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/usecase/register_usecase.dart';
import 'register_event.dart';
import 'register_state.dart';

/// Single ViewModel for register feature
/// Handles both UI state and business logic
/// Uses intent/event pattern
@injectable
class RegisterViewModel extends Cubit<RegisterState> {
  RegisterViewModel(this._registerUseCase) : super(const RegisterState());
final  RegisterUseCase _registerUseCase;

  /// Main intent handler
  /// Dispatches events to appropriate handlers
  void doIntent(RegisterEvent event) {
    switch (event) {
      case SwitchToSignUpEvent():
        _switchToSignUp();
      case SwitchToLoginEvent():
        _switchToLogin();
      case RegisterSubmitEvent():
        _registerUser(event);
    
    }
  }

  /// Switch to signup tab
  void _switchToSignUp() {
    if (!state.isSignUp) {
      emit(state.copyWith(
        isSignUp: true,
        errorMessage: null,
        isSuccess: false,
      ));
    }
  }

  /// Switch to login tab
  void _switchToLogin() {
    if (state.isSignUp) {
      emit(state.copyWith(
        isSignUp: false,
        errorMessage: null,
        isSuccess: false,
      ));
    }
  }

  /// Register new user
  Future<void> _registerUser(
    RegisterSubmitEvent event,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
    ));

    developer.log(
      'Registering user: ${event.registerRequestEntity.fullName}',
      name: 'RegisterViewModel',
    );

    final result = await _registerUseCase.call(
      event.registerRequestEntity,
    );

    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          registerResponseEntity: result.data,
        ));
      case ApiErrorResult():
        emit(state.copyWith(
          isLoading: false,
          errorMessage: result.failure.code,
        ));
    }
  }

}
