import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_explore_more_entity.dart';

class HomeExploreMoreSectionState {
  final bool isLoading;
  final bool isSuccess;
  final Failure? failure;
  final HomeExploreMoreEntity? data;

  const HomeExploreMoreSectionState({
    this.isLoading = false,
    this.isSuccess = false,
    this.failure,
    this.data,
  });

  HomeExploreMoreSectionState copyWith({
    bool? isLoading,
    bool? isSuccess,
    Failure? failure,
    bool clearFailure = false,
    HomeExploreMoreEntity? data,
    bool clearData = false,
  }) {
    return HomeExploreMoreSectionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      failure: clearFailure ? null : (failure ?? this.failure),
      data: clearData ? null : (data ?? this.data),
    );
  }
}
