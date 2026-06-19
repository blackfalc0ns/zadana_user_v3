import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class FavoritesState {
  const FavoritesState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isClearing = false,
    this.isLoadingMore = false,
    this.items = const [],
    this.itemsCount = 0,
    this.currentPage = 1,
    this.hasMore = true,
    this.failure,
    this.errorMessage,
    this.successMessage,
  });

  final bool isLoading;
  final bool isSuccess;
  final bool isClearing;
  final bool isLoadingMore;
  final List<ProductModel> items;
  final int itemsCount;
  final int currentPage;
  final bool hasMore;
  final Failure? failure;
  final String? errorMessage;
  final String? successMessage;

  FavoritesState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isClearing,
    bool? isLoadingMore,
    List<ProductModel>? items,
    int? itemsCount,
    int? currentPage,
    bool? hasMore,
    Failure? failure,
    String? errorMessage,
    String? successMessage,
    bool clearFailure = false,
    bool clearErrorMessage = false,
    bool clearSuccessMessage = false,
  }) {
    return FavoritesState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isClearing: isClearing ?? this.isClearing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      items: items ?? this.items,
      itemsCount: itemsCount ?? this.itemsCount,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      failure: clearFailure ? null : failure ?? this.failure,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      successMessage: clearSuccessMessage
          ? null
          : successMessage ?? this.successMessage,
    );
  }
}
