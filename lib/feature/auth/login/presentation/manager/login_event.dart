import '../../domain/entities/login_request_entity.dart';

/// Base event class for login feature
/// All login events extend this
sealed class LoginEvent {

}

/// Event to submit login form
class LoginSubmitEvent extends LoginEvent {
  final LoginRequestEntity requestEntity;

   LoginSubmitEvent({
    required this.requestEntity,
  });
}