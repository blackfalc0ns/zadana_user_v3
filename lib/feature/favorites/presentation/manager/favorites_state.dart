import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class FavoritesState {
  const FavoritesState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isClearing = false,
    this.items = const [],
    this.itemsCount = 0,
    this.failure,
    this.errorMessage,
    this.successMessage,
  });

  final bool isLoading;
  final bool isSuccess;
  final bool isClearing;
  final List<ProductModel> items;
  final int itemsCount;
  final Failure? failure;
  final String? errorMessage;
  final String? successMessage;

  FavoritesState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isClearing,
    List<ProductModel>? items,
    int? itemsCount,
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
      items: items ?? this.items,
      itemsCount: itemsCount ?? this.itemsCount,
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
