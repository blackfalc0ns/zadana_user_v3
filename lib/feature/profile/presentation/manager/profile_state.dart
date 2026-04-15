import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/profile/domain/entities/profile_response_entity.dart';

/// State for profile feature
/// Follows register pattern with minimal fields
class ProfileState {
  const ProfileState({
    this.isLoading = false,
    this.isUpdating = false,
    this.isSuccess = false,
    this.isUpdateSuccess = false,
    this.profileResponse,
    this.failure,
    this.updateFailure,
  });
  final bool isLoading;
  final bool isUpdating;
  final bool isSuccess;
  final bool isUpdateSuccess;
  final ProfileResponseEntity? profileResponse;
  final Failure? failure;
  final Failure? updateFailure;

  ProfileState copyWith({
    bool? isLoading,
    bool? isUpdating,
    bool? isSuccess,
    bool? isUpdateSuccess,
    ProfileResponseEntity? profileResponse,
    Failure? failure,
    Failure? updateFailure,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isSuccess: isSuccess ?? this.isSuccess,
      isUpdateSuccess: isUpdateSuccess ?? this.isUpdateSuccess,
      profileResponse: profileResponse ?? this.profileResponse,
      failure: failure,
      updateFailure: updateFailure,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfileState &&
        other.isLoading == isLoading &&
        other.isUpdating == isUpdating &&
        other.isSuccess == isSuccess &&
        other.isUpdateSuccess == isUpdateSuccess &&
        other.profileResponse == profileResponse &&
        other.failure == failure &&
        other.updateFailure == updateFailure;
  }

  @override
  int get hashCode => Object.hash(
    isLoading,
    isUpdating,
    isSuccess,
    isUpdateSuccess,
    profileResponse,
    failure,
    updateFailure,
  );
}
