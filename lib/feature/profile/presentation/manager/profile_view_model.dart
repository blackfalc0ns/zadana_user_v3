import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/profile/domain/entities/update_profile_request_entity.dart';
import 'package:zadana_user_v3/feature/profile/presentation/manager/profile_state.dart';
import '../../domain/usecase/profile_usecase.dart';
import '../../domain/usecase/update_profile_usecase.dart';
import 'profile_event.dart';

/// Profile ViewModel
/// Handles profile logic using intent/event pattern
@injectable
class ProfileViewModel extends Cubit<ProfileState> {
  ProfileViewModel(this._profileUseCase, this._updateProfileUseCase)
    : super(const ProfileState());
  final ProfileUseCase _profileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  /// Main intent handler
  /// Dispatches events to appropriate handlers
  void doIntent(ProfileEvent event) {
    switch (event) {
      case ProfileLoadEvent():
        _loadProfile();
      case ProfileUpdateEvent():
        _updateProfile(event.request);
      case ProfileSetLocalDataEvent():
        emit(
          state.copyWith(
            profileResponse: event.profile,
            isUpdateSuccess: false,
          ),
        );
    }
  }

  /// Load profile data
  Future<void> _loadProfile() async {
    emit(state.copyWith(isLoading: true));

    developer.log('Loading profile data', name: 'ProfileViewModel');

    final result = await _profileUseCase.call();

    switch (result) {
      case ApiSuccessResult():
        developer.log('Profile loaded successfully', name: 'ProfileViewModel');

        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            profileResponse: result.data,
          ),
        );

      case ApiErrorResult():
        developer.log(
          'Profile load failed: ${result.failure.errorMessage}',
          name: 'ProfileViewModel',
        );

        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            failure: result.failure,
          ),
        );
    }
  }

  Future<void> _updateProfile(UpdateProfileRequestEntity request) async {
    emit(state.copyWith(isUpdating: true, isUpdateSuccess: false));

    developer.log('Updating profile data', name: 'ProfileViewModel');

    final result = await _updateProfileUseCase.call(request);

    switch (result) {
      case ApiSuccessResult():
        developer.log('Profile updated successfully', name: 'ProfileViewModel');
        emit(
          state.copyWith(
            isUpdating: false,
            isUpdateSuccess: true,
            profileResponse: result.data,
          ),
        );
      case ApiErrorResult():
        developer.log(
          'Profile update failed: ${result.failure.errorMessage}',
          name: 'ProfileViewModel',
        );
        emit(
          state.copyWith(
            isUpdating: false,
            isUpdateSuccess: false,
            updateFailure: result.failure,
          ),
        );
    }
  }
}
