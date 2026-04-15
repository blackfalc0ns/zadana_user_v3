import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/entities/register_response_entity.dart';

/// State for register feature
/// Handles both UI state and business logic state
class RegisterState {
  const RegisterState({
    this.registerResponseEntity,
    this.isSignUp = false,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.failure,
  });
  final bool isSignUp;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final RegisterResponseEntity? registerResponseEntity;
  final Failure? failure;

  RegisterState copyWith({
    RegisterResponseEntity? registerResponseEntity,
    bool? isSignUp,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    Failure? failure,
  }) {
    return RegisterState(
      registerResponseEntity:
          registerResponseEntity ?? this.registerResponseEntity,
      isSignUp: isSignUp ?? this.isSignUp,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      failure: failure,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RegisterState &&
        other.isSignUp == isSignUp &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.isSuccess == isSuccess &&
        other.failure == failure;
  }

  @override
  int get hashCode =>
      Object.hash(isSignUp, isLoading, errorMessage, isSuccess, failure);
}
