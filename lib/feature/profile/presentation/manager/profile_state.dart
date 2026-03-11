import 'package:zadana_user_v3/feature/profile/domain/entities/profile_response_entity.dart';

/// State for profile feature
/// Follows register pattern with minimal fields
class ProfileState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final ProfileResponseEntity? profileResponse;

  const ProfileState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.profileResponse,
  });

  ProfileState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    ProfileResponseEntity? profileResponse,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      profileResponse: profileResponse ?? this.profileResponse,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfileState &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.isSuccess == isSuccess &&
        other.profileResponse == profileResponse;
  }

  @override
  int get hashCode => Object.hash(
        isLoading,
        errorMessage,
        isSuccess,
        profileResponse,
      );
}
