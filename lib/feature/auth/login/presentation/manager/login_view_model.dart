import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import '../../domain/entities/login_request_entity.dart';
import '../../domain/usecase/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

@injectable
class LoginViewModel extends Cubit<LoginState> {
  LoginViewModel(this._loginUseCase) : super(const LoginState());

  final LoginUseCase _loginUseCase;

  void doIntent(LoginEvent event) {
    switch (event) {
      case LoginSubmitEvent():
        _loginUser(event.requestEntity);
    }
  }

  Future<void> _loginUser(LoginRequestEntity requestEntity) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));

    developer.log(
      'Logging in user: ${requestEntity.identifier}',
      name: 'LoginViewModel',
    );

    final result = await _loginUseCase.call(requestEntity);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            loginResponse: result.data,
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
