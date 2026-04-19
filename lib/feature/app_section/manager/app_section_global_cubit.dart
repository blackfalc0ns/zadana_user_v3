import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/services/cart_count_sync_service.dart';
import 'package:zadana_user_v3/core/services/cart_refresh_service.dart';
import 'package:zadana_user_v3/core/services/favorite_sync_service.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/feature/app_section/manager/app_section_global_state.dart';
import 'package:zadana_user_v3/feature/cart/data/services/guest_cart_sync_service.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/add_cart_item_request_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/add_cart_item_usecase.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/get_cart_usecase.dart';
import 'package:zadana_user_v3/feature/cart/presentation/manager/cart_event.dart';
import 'package:zadana_user_v3/feature/cart/presentation/manager/cart_view_model.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_cubit.dart';
import 'package:zadana_user_v3/feature/favorites/data/repo/favorites_repository.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/manager/favorites_view_model.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_event.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_view_model.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_details_entity.dart';
import 'package:zadana_user_v3/feature/product_details/domain/usecase/product_details_usecase.dart';
import 'package:zadana_user_v3/feature/profile/presentation/manager/profile_event.dart';
import 'package:zadana_user_v3/feature/profile/presentation/manager/profile_view_model.dart';

class AppSectionGlobalCubit extends Cubit<AppSectionGlobalState> {
  AppSectionGlobalCubit({
    required HomeViewModel homeViewModel,
    required CartViewModel cartViewModel,
    required FavoritesViewModel favoritesViewModel,
    required ProfileViewModel profileViewModel,
    required CategoryViewModel categoryViewModel,
    required TokenService tokenService,
    required FavoritesRepository favoritesRepository,
    required GetCartUseCase getCartUseCase,
    required ProductDetailsUseCase productDetailsUseCase,
    required AddCartItemUseCase addCartItemUseCase,
    required GuestCartSyncService guestCartSyncService,
    FavoriteSyncService? favoriteSyncService,
    CartRefreshService? cartRefreshService,
    CartCountSyncService? cartCountSyncService,
  }) : _homeViewModel = homeViewModel,
       _cartViewModel = cartViewModel,
       _favoritesViewModel = favoritesViewModel,
       _profileViewModel = profileViewModel,
       _categoryViewModel = categoryViewModel,
       _tokenService = tokenService,
       _favoritesRepository = favoritesRepository,
       _getCartUseCase = getCartUseCase,
       _productDetailsUseCase = productDetailsUseCase,
       _addCartItemUseCase = addCartItemUseCase,
       _guestCartSyncService = guestCartSyncService,
       _favoriteSyncService = favoriteSyncService ?? FavoriteSyncService(),
       _cartRefreshService = cartRefreshService ?? CartRefreshService(),
       _cartCountSyncService = cartCountSyncService ?? CartCountSyncService(),
       super(const AppSectionGlobalState());

  final HomeViewModel _homeViewModel;
  final CartViewModel _cartViewModel;
  final FavoritesViewModel _favoritesViewModel;
  final ProfileViewModel _profileViewModel;
  final CategoryViewModel _categoryViewModel;
  final TokenService _tokenService;
  final FavoritesRepository _favoritesRepository;
  final GetCartUseCase _getCartUseCase;
  final ProductDetailsUseCase _productDetailsUseCase;
  final AddCartItemUseCase _addCartItemUseCase;
  final GuestCartSyncService _guestCartSyncService;
  final FavoriteSyncService _favoriteSyncService;
  final CartRefreshService _cartRefreshService;
  final CartCountSyncService _cartCountSyncService;

  Timer? _favoritesRefreshDebouncer;
  Timer? _cartRefreshDebouncer;
  bool _didInitialize = false;

  HomeViewModel get homeViewModel => _homeViewModel;
  CartViewModel get cartViewModel => _cartViewModel;
  FavoritesViewModel get favoritesViewModel => _favoritesViewModel;
  ProfileViewModel get profileViewModel => _profileViewModel;
  CategoryViewModel get categoryViewModel => _categoryViewModel;

  Future<void> initialize() async {
    if (_didInitialize) return;
    _didInitialize = true;

    _favoriteSyncService.addListener(_handleFavoriteMutation);
    _cartCountSyncService.addListener(_handleCartCountChanged);
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

    await _loadGlobalCounts();
    _warmUpFeatureData();
  }

  Future<void> refreshProfileAuthState() async {
    final token = await _tokenService.getToken();
    final isGuest = token == null || token.isEmpty;

    emit(state.copyWith(isAuthResolved: true, isGuest: isGuest));
    if (isGuest) return;

    _profileViewModel.doIntent(ProfileLoadEvent());
  }

  Future<FavoriteActionResult> addProductToFavorites(ProductModel product) async {
    if (product.isFavorite) {
      return const FavoriteActionResult(isSuccess: true, message: '');
    }

    final result = await _favoritesRepository.addFavorite(product.id);
    switch (result) {
      case ApiSuccessResult():
        _favoriteSyncService.notifyFavoriteChanged(
          productId: product.id,
          isFavorite: true,
        );
        return FavoriteActionResult(
          isSuccess: true,
          message: result.data.message,
        );
      case ApiErrorResult():
        return FavoriteActionResult(
          isSuccess: false,
          message: result.failure.errorMessage,
        );
    }
  }

  Future<FavoriteActionResult> removeProductFromFavorites(
    ProductModel product, {
    bool removeFromFavoritesState = false,
  }) async {
    final result = await _favoritesRepository.removeFavorite(product.id);
    switch (result) {
      case ApiSuccessResult():
        if (removeFromFavoritesState) {
          _favoritesViewModel.removeFavoriteLocally(product.id);
        }

        _favoriteSyncService.notifyFavoriteChanged(
          productId: product.id,
          isFavorite: false,
        );
        return FavoriteActionResult(
          isSuccess: true,
          message: result.data.message,
        );
      case ApiErrorResult():
        return FavoriteActionResult(
          isSuccess: false,
          message: result.failure.errorMessage,
        );
    }
  }

  Future<CartActionResult> addProductToCart(ProductModel product) async {
    final detailsResult = await _productDetailsUseCase.getProductDetails(
      product.id,
    );

    switch (detailsResult) {
      case ApiSuccessResult<ProductDetailsEntity>():
        final productId = detailsResult.data.masterProductId;
        if (productId.isEmpty) {
          return const CartActionResult(
            isSuccess: false,
            message: 'Product id is unavailable for this item.',
          );
        }

        final request = AddCartItemRequestEntity(productId: productId, quantity: 1);
        final addResult = await _addCartItemUseCase.call(request);
        switch (addResult) {
          case ApiSuccessResult():
            await _guestCartSyncService.cacheGuestCartItem(request);
            _cartCountSyncService.incrementBy(request.quantity);
            _cartRefreshService.notifyCartChanged();
            return CartActionResult(
              isSuccess: true,
              message: addResult.data.message,
            );
          case ApiErrorResult():
            return CartActionResult(
              isSuccess: false,
              message: addResult.failure.errorMessage,
            );
        }
      case ApiErrorResult<ProductDetailsEntity>():
        return CartActionResult(
          isSuccess: false,
          message: detailsResult.failure.errorMessage,
        );
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

  void _warmUpFeatureData() {
    _homeViewModel.doIntent(const HomeLoadEvent());
  }

  Future<void> _loadGlobalCounts() async {
    await Future.wait([_loadCartCount(), _loadFavoritesCount()]);
  }

  Future<void> _loadCartCount() async {
    final result = await _getCartUseCase.call();
    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(cartCount: result.data.summary.totalQuantity));
      case ApiErrorResult():
        break;
    }
  }

  Future<void> _loadFavoritesCount() async {
    final result = await _favoritesRepository.getFavorites();
    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(favoritesCount: result.data.itemsCount));
      case ApiErrorResult():
        break;
    }
  }

  void _handleFavoriteMutation() {
    final productId = _favoriteSyncService.productId;
    final isFavorite = _favoriteSyncService.isFavorite;
    if (productId == null || isFavorite == null) return;

    _homeViewModel.syncFavorite(productId: productId, isFavorite: isFavorite);
    _categoryViewModel.syncFavorite(
      productId: productId,
      isFavorite: isFavorite,
    );

    final nextCount = isFavorite
        ? state.favoritesCount + 1
        : math.max(0, state.favoritesCount - 1);
    emit(state.copyWith(favoritesCount: nextCount));

    _favoritesRefreshDebouncer?.cancel();
    _favoritesRefreshDebouncer = Timer(
      const Duration(milliseconds: 250),
      refreshFavoritesInBackground,
    );
  }

  void _handleCartCountChanged() {
    if (_cartCountSyncService.refreshRequested) {
      unawaited(_loadCartCount());
      return;
    }

    final absoluteCount = _cartCountSyncService.absoluteCount;
    if (absoluteCount != null) {
      emit(state.copyWith(cartCount: math.max(0, absoluteCount)));
      return;
    }

    emit(
      state.copyWith(
        cartCount: math.max(0, state.cartCount + _cartCountSyncService.delta),
      ),
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
    _cartCountSyncService.removeListener(_handleCartCountChanged);
    _cartRefreshService.removeListener(_handleCartMutation);
    await _homeViewModel.close();
    await _categoryViewModel.close();
    await _favoritesViewModel.close();
    await _profileViewModel.close();
    await _cartViewModel.close();
    await super.close();
  }
}

class FavoriteActionResult {
  const FavoriteActionResult({required this.isSuccess, required this.message});

  final bool isSuccess;
  final String message;
}

class CartActionResult {
  const CartActionResult({required this.isSuccess, required this.message});

  final bool isSuccess;
  final String message;
}
