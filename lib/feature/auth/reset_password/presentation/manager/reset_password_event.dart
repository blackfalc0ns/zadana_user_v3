import 'package:zadana_user_v3/feature/auth/reset_password/domain/entities/reset_password_request_entity.dart';

/// Base event class for reset password feature
abstract class ResetPasswordEvent {
  const ResetPasswordEvent();
}

/// Event to submit reset password form
class ResetPasswordSubmitEvent extends ResetPasswordEvent {
  const ResetPasswordSubmitEvent({required this.requestEntity});
  final ResetPasswordRequestEntity requestEntity;
}
