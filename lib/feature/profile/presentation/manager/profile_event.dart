/// Base event class for profile feature
/// All profile events extend this
sealed class ProfileEvent {}

/// Event to load profile data
class ProfileLoadEvent extends ProfileEvent {
  ProfileLoadEvent();
}
