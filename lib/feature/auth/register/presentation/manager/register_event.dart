import 'package:zadana_user_v3/feature/auth/register/domain/entities/register_request_entity.dart';

/// Base event class for register feature
/// All register events extend this
abstract class RegisterEvent {
  const RegisterEvent();
}

/// Event to switch to signup tab
class SwitchToSignUpEvent extends RegisterEvent {
  const SwitchToSignUpEvent();
}

/// Event to switch to login tab
class SwitchToLoginEvent extends RegisterEvent {
  const SwitchToLoginEvent();
}

/// Event to submit signup form
class RegisterSubmitEvent extends RegisterEvent {
  final RegisterRequestEntity registerRequestEntity;

  const RegisterSubmitEvent({required this.registerRequestEntity});
}

/// Event to submit login form
