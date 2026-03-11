import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/profile/presentation/manager/profile_state.dart';
import '../../domain/usecase/profile_usecase.dart';
import 'profile_event.dart';

/// Profile ViewModel
/// Handles profile logic using intent/event pattern
@injectable
class ProfileViewModel extends Cubit<ProfileState> {
  final ProfileUseCase _profileUseCase;

  ProfileViewModel(
    this._profileUseCase,
  ) : super(const ProfileState());

  /// Main intent handler
  /// Dispatches events to appropriate handlers
  void doIntent(ProfileEvent event) {
    switch (event) {
      case ProfileLoadEvent():
        _loadProfile();
    }
  }

  /// Load profile data
  Future<void> _loadProfile() async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
    ));

    developer.log(
      'Loading profile data',
      name: 'ProfileViewModel',
    );

    final result = await _profileUseCase.call();

    switch (result) {
      case ApiSuccessResult():
        developer.log(
          'Profile loaded successfully',
          name: 'ProfileViewModel',
        );

        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          profileResponse: result.data,
          errorMessage: null,
        ));

      case ApiErrorResult():
        developer.log(
          'Profile load failed: ${result.failure.errorMessage}',
          name: 'ProfileViewModel',
        );

        emit(state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: result.failure.errorMessage,
        ));
    }
  }
}
