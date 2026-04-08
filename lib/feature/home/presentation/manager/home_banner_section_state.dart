import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_banner_entity.dart';

class HomeBannerSectionState {
  final bool isLoading;
  final bool isSuccess;
  final Failure? failure;
  final HomeBannerEntity? data;

  const HomeBannerSectionState({
    this.isLoading = false,
    this.isSuccess = false,
    this.failure,
    this.data,
  });

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
