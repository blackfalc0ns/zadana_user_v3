import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_explore_more_entity.dart';

class HomeDynamicSectionState {
  final bool isLoading;
  final bool isSuccess;
  final Failure? failure;
  final List<HomeExploreMoreEntity>? data;

  const HomeDynamicSectionState({
    this.isLoading = false,
    this.isSuccess = false,
    this.failure,
    this.data,
  });

  HomeDynamicSectionState copyWith({
    bool? isLoading,
    bool? isSuccess,
    Failure? failure,
    bool clearFailure = false,
    List<HomeExploreMoreEntity>? data,
    bool clearData = false,
  }) {
    return HomeDynamicSectionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      failure: clearFailure ? null : (failure ?? this.failure),
      data: clearData ? null : (data ?? this.data),
    );
  }
}
