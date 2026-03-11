import 'package:zadana_user_v3/feature/auth/forget_password/domain/entities/forget_password_request_entity.dart';

/// Base event class for forget password feature
abstract class ForgetPasswordEvent {
  const ForgetPasswordEvent();
}

/// Event to submit forgot password form
class ForgetPasswordSubmitEvent extends ForgetPasswordEvent {
  final ForgetPasswordRequestEntity requestEntity;

  const ForgetPasswordSubmitEvent({
    required this.requestEntity,
  });
}
