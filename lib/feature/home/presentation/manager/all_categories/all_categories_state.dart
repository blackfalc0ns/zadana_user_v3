import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';

class AllCategoriesState {
  const AllCategoriesState({
    this.categories = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.failure,
  });

  final List<CategoryEntity> categories;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final Failure? failure;

  AllCategoriesState copyWith({
    List<CategoryEntity>? categories,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return AllCategoriesState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}
