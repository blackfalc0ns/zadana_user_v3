import 'package:zadana_user_v3/feature/auth/forget_password/domain/entities/forget_password_response_entity.dart';

/// State for forgot password feature
class ForgetPasswordState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final ForgetPasswordResponseEntity? responseEntity;

  const ForgetPasswordState({
    this.responseEntity,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  ForgetPasswordState copyWith({
    ForgetPasswordResponseEntity? responseEntity,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return ForgetPasswordState(
      responseEntity: responseEntity ?? this.responseEntity,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ForgetPasswordState &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.isSuccess == isSuccess;
  }

  @override
  int get hashCode =>
      Object.hash(isLoading, errorMessage, isSuccess);
}
