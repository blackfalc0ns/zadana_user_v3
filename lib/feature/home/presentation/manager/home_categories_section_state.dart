import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_categories_entity.dart';

class HomeCategoriesSectionState {
  final bool isLoading;
  final bool isSuccess;
  final Failure? failure;
  final HomeCategoriesEntity? data;

  const HomeCategoriesSectionState({
    this.isLoading = false,
    this.isSuccess = false,
    this.failure,
    this.data,
  });

  HomeCategoriesSectionState copyWith({
    bool? isLoading,
    bool? isSuccess,
    Failure? failure,
    bool clearFailure = false,
    HomeCategoriesEntity? data,
    bool clearData = false,
  }) {
    return HomeCategoriesSectionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      failure: clearFailure ? null : (failure ?? this.failure),
      data: clearData ? null : (data ?? this.data),
    );
  }
}
