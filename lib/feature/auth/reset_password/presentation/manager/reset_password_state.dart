import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/domain/entities/reset_password_response_entity.dart';

/// State for reset password feature
class ResetPasswordState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final ResetPasswordResponseEntity? responseEntity;
  final Failure? failure;

  const ResetPasswordState({
    this.responseEntity,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.failure,
  });

  ResetPasswordState copyWith({
    ResetPasswordResponseEntity? responseEntity,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    Failure? failure,
  }) {
    return ResetPasswordState(
      responseEntity: responseEntity ?? this.responseEntity,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      failure: failure,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResetPasswordState &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.isSuccess == isSuccess &&
        other.failure == failure;
  }

  @override
  int get hashCode => Object.hash(isLoading, errorMessage, isSuccess, failure);
}
