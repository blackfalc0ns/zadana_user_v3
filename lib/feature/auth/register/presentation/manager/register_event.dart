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
