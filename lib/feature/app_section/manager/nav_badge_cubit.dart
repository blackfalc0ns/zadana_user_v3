import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/services/cart_count_sync_service.dart';
import 'package:zadana_user_v3/core/services/favorite_sync_service.dart';
import 'package:zadana_user_v3/feature/app_section/manager/nav_badge_state.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/get_cart_usecase.dart';
import 'package:zadana_user_v3/feature/favorites/data/repo/favorites_repository.dart';
import 'package:zadana_user_v3/feature/favorites/domain/entities/favorites_response_entity.dart';

class NavBadgeCubit extends Cubit<NavBadgeState> {
  NavBadgeCubit(
    this._getCartUseCase,
    this._favoritesRepository,
    this._favoriteSyncService,
    this._cartCountSyncService,
  ) : super(const NavBadgeState()) {
    _favoriteSyncService.addListener(_handleFavoriteChanged);
    _cartCountSyncService.addListener(_handleCartCountChanged);
  }

  final GetCartUseCase _getCartUseCase;
  final FavoritesRepository _favoritesRepository;
  final FavoriteSyncService _favoriteSyncService;
  final CartCountSyncService _cartCountSyncService;

  Future<void> loadCounts() async {
    await Future.wait([
      _loadCartCount(),
      _loadFavoritesCount(),
    ]);
  }

  Future<void> _loadCartCount() async {
    final result = await _getCartUseCase.call();
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            cartCount: result.data.summary.totalQuantity,
          ),
        );
      case ApiErrorResult():
        // Keep the current count on failure.
        break;
    }
  }

  Future<void> _loadFavoritesCount() async {
    final result = await _favoritesRepository.getFavorites();
    switch (result) {
      case ApiSuccessResult<FavoritesResponseEntity>():
        emit(
          state.copyWith(
            favoritesCount: result.data.itemsCount,
          ),
        );
      case ApiErrorResult():
        break;
    }
  }

  void _handleFavoriteChanged() {
    final isFavorite = _favoriteSyncService.isFavorite;
    if (isFavorite == null) return;

    final nextCount = isFavorite
        ? state.favoritesCount + 1
        : math.max(0, state.favoritesCount - 1);
    emit(state.copyWith(favoritesCount: nextCount));
  }

  void _handleCartCountChanged() {
    if (_cartCountSyncService.refreshRequested) {
      _loadCartCount();
      return;
    }

    final absoluteCount = _cartCountSyncService.absoluteCount;
    if (absoluteCount != null) {
      emit(state.copyWith(cartCount: math.max(0, absoluteCount)));
      return;
    }

    final nextCount = math.max(0, state.cartCount + _cartCountSyncService.delta);
    emit(state.copyWith(cartCount: nextCount));
  }

  @override
  Future<void> close() {
    _favoriteSyncService.removeListener(_handleFavoriteChanged);
    _cartCountSyncService.removeListener(_handleCartCountChanged);
    return super.close();
  }
}
