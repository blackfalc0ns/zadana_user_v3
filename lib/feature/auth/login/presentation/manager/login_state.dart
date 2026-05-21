import 'package:zadana_user_v3/core/network/failures.dart';
import '../../domain/entities/login_response_entity.dart';

/// State for login feature
/// Handles loading, success, error states
class LoginState {
  const LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.loginResponse,
    this.failure,
    this.identifier,
    this.isEmailNotVerified = false,
  });
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final LoginResponseEntity? loginResponse;
  final Failure? failure;
  final String? identifier;
  final bool isEmailNotVerified;

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    LoginResponseEntity? loginResponse,
    Failure? failure,
    String? identifier,
    bool? isEmailNotVerified,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      loginResponse: loginResponse ?? this.loginResponse,
      failure: failure,
      identifier: identifier ?? this.identifier,
      isEmailNotVerified: isEmailNotVerified ?? this.isEmailNotVerified,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginState &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.isSuccess == isSuccess &&
        other.loginResponse == loginResponse &&
        other.failure == failure &&
        other.identifier == identifier &&
        other.isEmailNotVerified == isEmailNotVerified;
  }

  @override
  int get hashCode => Object.hash(
    isLoading,
    errorMessage,
    isSuccess,
    loginResponse,
    failure,
    identifier,
    isEmailNotVerified,
  );
}
