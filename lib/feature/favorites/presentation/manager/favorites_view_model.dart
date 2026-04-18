import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/services/favorite_sync_service.dart';
import 'package:zadana_user_v3/feature/favorites/data/repo/favorites_repository.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/manager/favorites_state.dart';

class FavoritesViewModel extends Cubit<FavoritesState> {
  FavoritesViewModel(this._repository) : super(const FavoritesState());

  final FavoritesRepository _repository;
  final FavoriteSyncService _favoriteSyncService = FavoriteSyncService();

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

    final result = await _repository.getFavorites();

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
    final result = await _repository.removeFavorite(productId);

    switch (result) {
      case ApiSuccessResult():
        _favoriteSyncService.notifyFavoriteChanged(
          productId: productId,
          isFavorite: false,
        );
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

    final result = await _repository.clearFavorites();

    switch (result) {
      case ApiSuccessResult():
        for (final item in currentItems) {
          _favoriteSyncService.notifyFavoriteChanged(
            productId: item.id,
            isFavorite: false,
          );
        }
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
