import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class FavoritesState {
  const FavoritesState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isClearing = false,
    this.items = const [],
    this.itemsCount = 0,
    this.errorMessage,
    this.successMessage,
  });

  final bool isLoading;
  final bool isSuccess;
  final bool isClearing;
  final List<ProductModel> items;
  final int itemsCount;
  final String? errorMessage;
  final String? successMessage;

  FavoritesState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isClearing,
    List<ProductModel>? items,
    int? itemsCount,
    String? errorMessage,
    String? successMessage,
    bool clearErrorMessage = false,
    bool clearSuccessMessage = false,
  }) {
    return FavoritesState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isClearing: isClearing ?? this.isClearing,
      items: items ?? this.items,
      itemsCount: itemsCount ?? this.itemsCount,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      successMessage: clearSuccessMessage
          ? null
          : successMessage ?? this.successMessage,
    );
  }
}
