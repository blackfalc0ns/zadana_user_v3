import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/profile/domain/entities/profile_response_entity.dart';

/// State for profile feature
/// Follows register pattern with minimal fields
class ProfileState {
  final bool isLoading;
  final bool isSuccess;
  final ProfileResponseEntity? profileResponse;
  final Failure? failure;

  const ProfileState({
    this.isLoading = false,
    this.isSuccess = false,
    this.profileResponse,
    this.failure,
  });

  ProfileState copyWith({
    bool? isLoading,
    bool? isSuccess,
    ProfileResponseEntity? profileResponse,
    Failure? failure,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      profileResponse: profileResponse ?? this.profileResponse,
      failure: failure,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfileState &&
        other.isLoading == isLoading &&
        other.isSuccess == isSuccess &&
        other.profileResponse == profileResponse &&
        other.failure == failure;
  }

  @override
  int get hashCode => Object.hash(
        isLoading,
        isSuccess,
        profileResponse,
        failure,
      );
}
