import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_response_entity.dart';

class HomeAppBarSectionState {
  const HomeAppBarSectionState({
    this.isLoading = false,
    this.isSuccess = false,
    this.failure,
    this.data,
  });
  final bool isLoading;
  final bool isSuccess;
  final Failure? failure;
  final HomeAppBarEntity? data;

  HomeAppBarSectionState copyWith({
    bool? isLoading,
    bool? isSuccess,
    Failure? failure,
    bool clearFailure = false,
    HomeAppBarEntity? data,
    bool clearData = false,
  }) {
    return HomeAppBarSectionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      failure: clearFailure ? null : (failure ?? this.failure),
      data: clearData ? null : (data ?? this.data),
    );
  }
}
