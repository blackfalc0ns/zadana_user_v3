import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_banner_entity.dart';

class HomeBannerSectionState {
  const HomeBannerSectionState({
    this.isLoading = false,
    this.isSuccess = false,
    this.failure,
    this.data,
  });
  final bool isLoading;
  final bool isSuccess;
  final Failure? failure;
  final HomeBannerEntity? data;

  HomeBannerSectionState copyWith({
    bool? isLoading,
    bool? isSuccess,
    Failure? failure,
    bool clearFailure = false,
    HomeBannerEntity? data,
    bool clearData = false,
  }) {
    return HomeBannerSectionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      failure: clearFailure ? null : (failure ?? this.failure),
      data: clearData ? null : (data ?? this.data),
    );
  }
}
