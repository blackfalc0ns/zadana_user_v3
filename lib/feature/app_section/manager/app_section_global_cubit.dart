import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/services/cart_refresh_service.dart';
import 'package:zadana_user_v3/core/services/favorite_sync_service.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/feature/app_section/manager/app_section_global_state.dart';
import 'package:zadana_user_v3/feature/cart/presentation/manager/cart_event.dart';
import 'package:zadana_user_v3/feature/cart/presentation/manager/cart_view_model.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_view_model.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/manager/favorites_view_model.dart';
import 'package:zadana_user_v3/feature/profile/presentation/manager/profile_event.dart';
import 'package:zadana_user_v3/feature/profile/presentation/manager/profile_view_model.dart';

class AppSectionGlobalCubit extends Cubit<AppSectionGlobalState> {
  AppSectionGlobalCubit({
    required CartViewModel cartViewModel,
    required FavoritesViewModel favoritesViewModel,
    required ProfileViewModel profileViewModel,
    required CategoryViewModel categoryViewModel,
    required TokenService tokenService,
    FavoriteSyncService? favoriteSyncService,
    CartRefreshService? cartRefreshService,
  }) : _cartViewModel = cartViewModel,
       _favoritesViewModel = favoritesViewModel,
       _profileViewModel = profileViewModel,
       _categoryViewModel = categoryViewModel,
       _tokenService = tokenService,
       _favoriteSyncService = favoriteSyncService ?? FavoriteSyncService(),
       _cartRefreshService = cartRefreshService ?? CartRefreshService(),
       super(const AppSectionGlobalState());

  final CartViewModel _cartViewModel;
  final FavoritesViewModel _favoritesViewModel;
  final ProfileViewModel _profileViewModel;
  final CategoryViewModel _categoryViewModel;
  final TokenService _tokenService;
  final FavoriteSyncService _favoriteSyncService;
  final CartRefreshService _cartRefreshService;

  Timer? _favoritesRefreshDebouncer;
  Timer? _cartRefreshDebouncer;
  bool _didInitialize = false;

  CartViewModel get cartViewModel => _cartViewModel;
  FavoritesViewModel get favoritesViewModel => _favoritesViewModel;
  ProfileViewModel get profileViewModel => _profileViewModel;
  CategoryViewModel get categoryViewModel => _categoryViewModel;

  Future<void> initialize() async {
    if (_didInitialize) return;
    _didInitialize = true;

    _favoriteSyncService.addListener(_handleFavoriteMutation);
    _cartRefreshService.addListener(_handleCartMutation);

    emit(state.copyWith(isInitializing: true));

    final token = await _tokenService.getToken();
    final isGuest = token == null || token.isEmpty;

    emit(
      state.copyWith(
        isInitializing: false,
        isAuthResolved: true,
        isGuest: isGuest,
      ),
    );

    _warmUpFeatureData(isGuest: isGuest);
  }

  Future<void> refreshProfileAuthState() async {
    final token = await _tokenService.getToken();
    final isGuest = token == null || token.isEmpty;

    emit(state.copyWith(isAuthResolved: true, isGuest: isGuest));

    if (isGuest) return;
    _profileViewModel.doIntent(ProfileLoadEvent());
  }

  void _warmUpFeatureData({required bool isGuest}) {
    _categoryViewModel.initialize();
    refreshCartInBackground();
    refreshFavoritesInBackground();
    if (!isGuest) {
      _profileViewModel.doIntent(ProfileLoadEvent());
    }
  }

  void refreshCartInBackground() {
    final loadedVendorId = _cartViewModel.state.loadedVendorId;
    _cartViewModel
      ..doIntent(const CartLoadVendorsEvent())
      ..doIntent(CartLoadItemsEvent(vendorId: loadedVendorId));
  }

  void refreshFavoritesInBackground() {
    _favoritesViewModel.loadFavorites(silent: true);
  }

  void _handleFavoriteMutation() {
    _favoritesRefreshDebouncer?.cancel();
    _favoritesRefreshDebouncer = Timer(
      const Duration(milliseconds: 250),
      refreshFavoritesInBackground,
    );
  }

  void _handleCartMutation() {
    final shouldRefresh = _cartRefreshService.consumeRefreshRequest();

    if (!shouldRefresh) return;

    _cartRefreshDebouncer?.cancel();
    _cartRefreshDebouncer = Timer(
      const Duration(milliseconds: 300),
      refreshCartInBackground,
    );
  }

  @override
  Future<void> close() async {
    _favoritesRefreshDebouncer?.cancel();
    _cartRefreshDebouncer?.cancel();
    _favoriteSyncService.removeListener(_handleFavoriteMutation);
    _cartRefreshService.removeListener(_handleCartMutation);
    await _categoryViewModel.close();
    await _favoritesViewModel.close();
    await _profileViewModel.close();
    await _cartViewModel.close();
    await super.close();
  }
}
