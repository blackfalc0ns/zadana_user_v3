import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_featured_entity.dart';

class HomeFeaturedSectionState {
  const HomeFeaturedSectionState({
    this.isLoading = false,
    this.isSuccess = false,
    this.failure,
    this.data,
  });
  final bool isLoading;
  final bool isSuccess;
  final Failure? failure;
  final HomeFeaturedEntity? data;

  HomeFeaturedSectionState copyWith({
    bool? isLoading,
    bool? isSuccess,
    Failure? failure,
    bool clearFailure = false,
    HomeFeaturedEntity? data,
    bool clearData = false,
  }) {
    return HomeFeaturedSectionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      failure: clearFailure ? null : (failure ?? this.failure),
      data: clearData ? null : (data ?? this.data),
    );
  }
}
