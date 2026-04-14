import 'package:zadana_user_v3/feature/profile/domain/entities/profile_response_entity.dart';
import 'package:zadana_user_v3/feature/profile/domain/entities/update_profile_request_entity.dart';

/// Base event class for profile feature
/// All profile events extend this
sealed class ProfileEvent {}

/// Event to load profile data
class ProfileLoadEvent extends ProfileEvent {
  ProfileLoadEvent();
}

class ProfileUpdateEvent extends ProfileEvent {
  ProfileUpdateEvent(this.request);

  final UpdateProfileRequestEntity request;
}

class ProfileSetLocalDataEvent extends ProfileEvent {
  ProfileSetLocalDataEvent(this.profile);

  final ProfileResponseEntity profile;
}
