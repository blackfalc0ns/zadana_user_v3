import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/favorites/domain/usecase/clear_favorites_usecase.dart';
import 'package:zadana_user_v3/feature/favorites/domain/usecase/get_favorites_usecase.dart';
import 'package:zadana_user_v3/feature/favorites/domain/usecase/remove_favorite_usecase.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/manager/favorites_state.dart';

@injectable
class FavoritesViewModel extends Cubit<FavoritesState> {
  FavoritesViewModel(
    this._getFavoritesUseCase,
    this._removeFavoriteUseCase,
    this._clearFavoritesUseCase,
  ) : super(const FavoritesState());

  final GetFavoritesUseCase _getFavoritesUseCase;
  final RemoveFavoriteUseCase _removeFavoriteUseCase;
  final ClearFavoritesUseCase _clearFavoritesUseCase;

  Future<void> loadFavorites({bool silent = false}) async {
    final showBlockingLoader = !silent || state.items.isEmpty;

    emit(
      state.copyWith(
        isLoading: showBlockingLoader,
        isSuccess: false,
        clearFailure: true,
        clearErrorMessage: true,
      ),
    );

    developer.log('Loading favorites', name: 'FavoritesViewModel');

    final result = await _getFavoritesUseCase();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            items: result.data.items,
            itemsCount: result.data.itemsCount,
            clearFailure: true,
            clearErrorMessage: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            failure: result.failure,
            errorMessage: result.failure.errorMessage,
            clearSuccessMessage: true,
          ),
        );
    }
  }

  void removeFavoriteLocally(String productId) {
    final updatedItems = state.items
        .where((item) => item.id != productId)
        .toList();
    emit(state.copyWith(items: updatedItems, itemsCount: updatedItems.length));
  }

  Future<void> removeFavorite(String productId) async {
    final result = await _removeFavoriteUseCase(productId);

    switch (result) {
      case ApiSuccessResult():
        final updatedItems = state.items
            .where((item) => item.id != productId)
            .toList();
        emit(
          state.copyWith(
            items: updatedItems,
            itemsCount: result.data.itemsCount,
            successMessage: result.data.message,
            clearFailure: true,
            clearErrorMessage: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            failure: result.failure,
            errorMessage: result.failure.errorMessage,
            clearSuccessMessage: true,
          ),
        );
    }
  }

  void clearAllLocally() {
    emit(state.copyWith(items: const [], itemsCount: 0));
  }

  Future<void> clearAllFavorites() async {
    final currentItems = state.items;
    emit(
      state.copyWith(
        isClearing: true,
        clearFailure: true,
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    final result = await _clearFavoritesUseCase(
      productIds: currentItems.map((item) => item.id),
    );

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isClearing: false,
            items: const [],
            itemsCount: 0,
            successMessage: result.data.message,
            clearFailure: true,
            clearErrorMessage: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isClearing: false,
            failure: result.failure,
            errorMessage: result.failure.errorMessage,
            clearSuccessMessage: true,
          ),
        );
    }
  }

  void clearFailure() {
    emit(state.copyWith(clearFailure: true));
  }

  void clearError() {
    emit(state.copyWith(clearErrorMessage: true));
  }

  void clearSuccess() {
    emit(state.copyWith(clearSuccessMessage: true));
  }
}
