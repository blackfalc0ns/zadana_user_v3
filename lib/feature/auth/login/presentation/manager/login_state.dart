import '../../domain/entities/login_response_entity.dart';

/// State for login feature
/// Handles loading, success, error states
class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final LoginResponseEntity? loginResponse;

  const LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.loginResponse,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    LoginResponseEntity? loginResponse,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      loginResponse: loginResponse ?? this.loginResponse,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginState &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.isSuccess == isSuccess &&
        other.loginResponse == loginResponse;
  }

  @override
  int get hashCode => Object.hash(
        isLoading,
        errorMessage,
        isSuccess,
        loginResponse,
      );
}