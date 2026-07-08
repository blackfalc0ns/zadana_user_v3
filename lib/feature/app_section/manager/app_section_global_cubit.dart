import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/services/cart_navigation_service.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/feature/app_section/manager/app_section_global_state.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/add_cart_item_request_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/repo/cart_repository.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/add_cart_item_usecase.dart';
import 'package:zadana_user_v3/feature/cart/presentation/manager/cart_event.dart';
import 'package:zadana_user_v3/feature/cart/presentation/manager/cart_view_model.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_view_model.dart';
import 'package:zadana_user_v3/feature/favorites/data/repo/favorites_repository.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/manager/favorites_view_model.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_event.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_view_model.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_details_entity.dart';
import 'package:zadana_user_v3/feature/product_details/domain/usecase/product_details_usecase.dart';
import 'package:zadana_user_v3/feature/profile/presentation/manager/profile_event.dart';
import 'package:zadana_user_v3/feature/profile/presentation/manager/profile_view_model.dart';

@injectable
class AppSectionGlobalCubit extends Cubit<AppSectionGlobalState> {
  AppSectionGlobalCubit({
    required HomeViewModel homeViewModel,
    required CartViewModel cartViewModel,
    required FavoritesViewModel favoritesViewModel,
    required ProfileViewModel profileViewModel,
    required CategoryViewModel categoryViewModel,
    required TokenService tokenService,
    required FavoritesRepository favoritesRepository,
    required CartRepository cartRepository,
    required ProductDetailsUseCase productDetailsUseCase,
    required AddCartItemUseCase addCartItemUseCase,
  }) : _homeViewModel = homeViewModel,
       _cartViewModel = cartViewModel,
       _favoritesViewModel = favoritesViewModel,
       _profileViewModel = profileViewModel,
       _categoryViewModel = categoryViewModel,
       _tokenService = tokenService,
       _favoritesRepository = favoritesRepository,
       _cartRepository = cartRepository,
       _productDetailsUseCase = productDetailsUseCase,
       _addCartItemUseCase = addCartItemUseCase,
       super(const AppSectionGlobalState());

  final HomeViewModel _homeViewModel;
  final CartViewModel _cartViewModel;
  final FavoritesViewModel _favoritesViewModel;
  final ProfileViewModel _profileViewModel;
  final CategoryViewModel _categoryViewModel;
  final TokenService _tokenService;
  final FavoritesRepository _favoritesRepository;
  final CartRepository _cartRepository;
  final ProductDetailsUseCase _productDetailsUseCase;
  final AddCartItemUseCase _addCartItemUseCase;
  final CartNavigationService _cartNavigationService = CartNavigationService();

  StreamSubscription<FavoriteMutationEvent>? _favoriteMutationsSubscription;
  StreamSubscription<CartMutationEvent>? _cartMutationsSubscription;
  Timer? _favoritesRefreshDebouncer;
  Timer? _cartRefreshDebouncer;
  bool _didInitialize = false;
  bool _cartTabActivated = false;
  bool _favoritesTabActivated = false;

  HomeViewModel get homeViewModel => _homeViewModel;
  CartViewModel get cartViewModel => _cartViewModel;
  FavoritesViewModel get favoritesViewModel => _favoritesViewModel;
  ProfileViewModel get profileViewModel => _profileViewModel;
  CategoryViewModel get categoryViewModel => _categoryViewModel;
  List<CategoryEntity> get homeCategoriesForShopping {
    final items =
        _homeViewModel.state.categoriesSection.data?.items ?? const [];
    return items
        .where((item) => item.id.isNotEmpty && item.name.isNotEmpty)
        .map(
          (item) => CategoryEntity(
            id: item.id,
            name: item.name,
            imageAsset: item.imageUrl,
            emoji: item.name.isNotEmpty ? item.name.substring(0, 1) : '',
          ),
        )
        .toList(growable: false);
  }

  Future<void> initialize() async {
    if (_didInitialize) return;
    _didInitialize = true;

    _favoriteMutationsSubscription = _favoritesRepository.mutations.listen(
      _handleFavoriteMutation,
    );
    _cartMutationsSubscription = _cartRepository.mutations.listen(
      _handleCartMutation,
    );
    _cartNavigationService.addListener(_handleCartNavigationRequest);

    emit(state.copyWith(isInitializing: true));
    _warmUpFeatureData();

    final token = await _tokenService.getToken();
    final isGuest = token == null || token.isEmpty;

    emit(
      state.copyWith(
        isInitializing: false,
        isAuthResolved: true,
        isGuest: isGuest,
      ),
    );
  }

  void markCartTabActivated() {
    _cartTabActivated = true;
  }

  void markFavoritesTabActivated() {
    _favoritesTabActivated = true;
  }

  Future<void> refreshProfileAuthState() async {
    final token = await _tokenService.getToken();
    final isGuest = token == null || token.isEmpty;

    emit(state.copyWith(isAuthResolved: true, isGuest: isGuest));
    if (isGuest) return;

    _profileViewModel.doIntent(ProfileLoadEvent());
  }

  Future<FavoriteActionResult> addProductToFavorites(
    ProductModel product,
  ) async {
    if (product.isFavorite) {
      return const FavoriteActionResult(isSuccess: true, message: '');
    }

    final result = await _favoritesRepository.addFavorite(product.id);
    switch (result) {
      case ApiSuccessResult():
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
    // Always fetch product details to check for variants before adding to cart.
    // The listing API doesn't include variant_count, so we must check details.
    final detailsResult = await _productDetailsUseCase.getProductDetails(
      product.id,
    );

    switch (detailsResult) {
      case ApiSuccessResult<ProductDetailsEntity>():
        final details = detailsResult.data;
        // If the product has more than one variant, show selection sheet.
        if (details.variantOptions.length > 1) {
          return CartActionResult(
            isSuccess: false,
            message: '',
            requiresVariantSelection: true,
            productDetails: details,
          );
        }
        // Single variant or no variants — add directly.
        final productId = details.variantOptions.length == 1
            ? details.variantOptions.first.id
            : details.masterProductId.isNotEmpty
            ? details.masterProductId
            : product.id;
        if (productId.isEmpty) {
          return const CartActionResult(
            isSuccess: false,
            message: 'Product id is unavailable for this item.',
          );
        }
        final request = AddCartItemRequestEntity(
          productId: productId,
          quantity: 1,
        );
        final addResult = await _addCartItemUseCase.call(request);
        switch (addResult) {
          case ApiSuccessResult():
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

  /// Adds a specific variant to cart (called after user selects from bottom sheet).
  Future<CartActionResult> addVariantToCart(String variantId) async {
    if (variantId.isEmpty) {
      return const CartActionResult(
        isSuccess: false,
        message: 'Product id is unavailable for this item.',
      );
    }

    final request = AddCartItemRequestEntity(productId: variantId, quantity: 1);
    final addResult = await _addCartItemUseCase.call(request);
    switch (addResult) {
      case ApiSuccessResult():
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
  }

  void refreshCartInBackground() {
    if (!_cartTabActivated) return;

    final loadedVendorId = _cartViewModel.state.loadedVendorId;
    _cartViewModel
      ..doIntent(const CartLoadVendorsEvent())
      ..doIntent(CartLoadItemsEvent(vendorId: loadedVendorId));
  }

  void refreshFavoritesInBackground() {
    if (!_favoritesTabActivated) return;

    _favoritesViewModel.loadFavorites(silent: true);
  }

  void _warmUpFeatureData() {
    _homeViewModel.doIntent(const HomeLoadEvent());
  }

  void _handleFavoriteMutation(FavoriteMutationEvent event) {
    for (final productId in event.productIds) {
      _homeViewModel.syncFavorite(
        productId: productId,
        isFavorite: event.isFavorite,
      );
      _categoryViewModel.syncFavorite(
        productId: productId,
        isFavorite: event.isFavorite,
      );
    }

    final delta = event.productIds.length;
    final nextCount = event.isFavorite
        ? state.favoritesCount + delta
        : math.max(0, state.favoritesCount - delta);
    emit(state.copyWith(favoritesCount: nextCount));

    if (event.skipBackgroundRefresh) {
      return;
    }

    _favoritesRefreshDebouncer?.cancel();
    _favoritesRefreshDebouncer = Timer(
      const Duration(milliseconds: 250),
      refreshFavoritesInBackground,
    );
  }

  void _handleCartMutation(CartMutationEvent event) {
    final absoluteCount = event.absoluteCount;
    if (absoluteCount != null) {
      emit(state.copyWith(cartCount: math.max(0, absoluteCount)));
    } else if (event.delta != 0) {
      emit(
        state.copyWith(cartCount: math.max(0, state.cartCount + event.delta)),
      );
    }

    if (!event.refreshRequested) {
      return;
    }

    _cartRefreshDebouncer?.cancel();
    _cartRefreshDebouncer = Timer(
      const Duration(milliseconds: 300),
      refreshCartInBackground,
    );
  }

  void _handleCartNavigationRequest() {
    if (!_cartNavigationService.consumeResetBadgeRequest()) {
      return;
    }

    emit(state.copyWith(cartCount: 0));
  }

  @override
  Future<void> close() async {
    _cartNavigationService.removeListener(_handleCartNavigationRequest);
    _favoritesRefreshDebouncer?.cancel();
    _cartRefreshDebouncer?.cancel();
    await _favoriteMutationsSubscription?.cancel();
    await _cartMutationsSubscription?.cancel();
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
  const CartActionResult({
    required this.isSuccess,
    required this.message,
    this.requiresVariantSelection = false,
    this.productDetails,
  });

  final bool isSuccess;
  final String message;
  final bool requiresVariantSelection;
  final ProductDetailsEntity? productDetails;
}
