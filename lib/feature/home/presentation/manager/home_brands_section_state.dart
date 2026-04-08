import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_brands_entity.dart';

class HomeBrandsSectionState {
  final bool isLoading;
  final bool isSuccess;
  final Failure? failure;
  final HomeBrandsEntity? data;

  const HomeBrandsSectionState({
    this.isLoading = false,
    this.isSuccess = false,
    this.failure,
    this.data,
  });

  HomeBrandsSectionState copyWith({
    bool? isLoading,
    bool? isSuccess,
    Failure? failure,
    bool clearFailure = false,
    HomeBrandsEntity? data,
    bool clearData = false,
  }) {
    return HomeBrandsSectionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      failure: clearFailure ? null : (failure ?? this.failure),
      data: clearData ? null : (data ?? this.data),
    );
  }
}
