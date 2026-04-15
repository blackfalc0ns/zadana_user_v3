import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_recommended_entity.dart';

class HomeRecommendedSectionState {
  const HomeRecommendedSectionState({
    this.isLoading = false,
    this.isSuccess = false,
    this.failure,
    this.data,
  });
  final bool isLoading;
  final bool isSuccess;
  final Failure? failure;
  final HomeRecommendedEntity? data;

  HomeRecommendedSectionState copyWith({
    bool? isLoading,
    bool? isSuccess,
    Failure? failure,
    bool clearFailure = false,
    HomeRecommendedEntity? data,
    bool clearData = false,
  }) {
    return HomeRecommendedSectionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      failure: clearFailure ? null : (failure ?? this.failure),
      data: clearData ? null : (data ?? this.data),
    );
  }
}
