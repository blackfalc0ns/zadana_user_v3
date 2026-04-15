import 'dart:developer' as developer;
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/core/services/cart_count_sync_service.dart';
import 'package:zadana_user_v3/core/services/language_service.dart';
import 'package:zadana_user_v3/feature/cart/data/services/guest_cart_sync_service.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/add_cart_item_request_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/add_cart_item_usecase.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/get_cart_usecase.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_details_entity.dart';
import 'package:zadana_user_v3/feature/product_details/domain/usecase/product_details_usecase.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/manager/product_details_event.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/manager/product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit({
    required ProductDetailsUseCase productDetailsUseCase,
    required AddCartItemUseCase addCartItemUseCase,
    required GetCartUseCase getCartUseCase,
    required GuestCartSyncService guestCartSyncService,
    required LanguageService languageService,
  }) : _productDetailsUseCase = productDetailsUseCase,
       _addCartItemUseCase = addCartItemUseCase,
       _getCartUseCase = getCartUseCase,
       _guestCartSyncService = guestCartSyncService,
       _languageService = languageService,
       super(const ProductDetailsState());

  final ProductDetailsUseCase _productDetailsUseCase;
  final AddCartItemUseCase _addCartItemUseCase;
  final GetCartUseCase _getCartUseCase;
  final GuestCartSyncService _guestCartSyncService;
  final LanguageService _languageService;
  final CartCountSyncService _cartCountSyncService = CartCountSyncService();

  String? _productId;
  bool _isCartListenerAttached = false;

  AppLocalizations get _l10n {
    final languageCode = _languageService.getLanguageCode();
    return lookupAppLocalizations(Locale(languageCode));
  }

  Future<void> doIntent(ProductDetailsEvent event) async {
    switch (event) {
      case InitializeProductDetailsEvent():
        await _initialize(
          productId: event.productId,
          activeProductId: event.activeProductId,
        );
      case LoadProductDetailsEvent():
        await _loadProductDetails();
      case IncreaseProductQuantityEvent():
        _increaseQuantity();
      case DecreaseProductQuantityEvent():
        _decreaseQuantity();
      case SetActiveProductDetailsEvent():
        _setActiveProduct(event.productId);
      case AddProductToCartEvent():
        await _addToCart();
      case ClearProductDetailsFeedbackEvent():
        _clearFeedback();
    }
  }

  Future<void> _initialize({
    required String productId,
    String? activeProductId,
  }) async {
    _productId = productId;
    _attachCartListenerIfNeeded();
    emit(
      state.copyWith(
        activeProductId: activeProductId,
        clearLoadFailure: true,
        clearAddToCartFailure: true,
        clearAddToCartSuccessMessage: true,
      ),
    );
    await _loadProductDetails();
    await _loadInitialCartCount();
  }

  Future<void> _loadProductDetails() async {
    final productId = _productId;
    if (productId == null || productId.isEmpty) return;

    emit(
      state.copyWith(
        isLoading: true,
        clearLoadFailure: true,
      ),
    );

    developer.log(
      'Loading product details: $productId',
      name: 'ProductDetailsCubit',
    );

    final result = await _productDetailsUseCase.getProductDetails(productId);
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult<ProductDetailsEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            productDetails: result.data,
            clearLoadFailure: true,
          ),
        );
      case ApiErrorResult<ProductDetailsEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            loadFailure: result.failure,
          ),
        );
    }
  }

  void _increaseQuantity() {
    emit(
      state.copyWith(
        quantity: state.quantity + 1,
        clearAddToCartFailure: true,
        clearAddToCartSuccessMessage: true,
      ),
    );
  }

  void _decreaseQuantity() {
    if (state.quantity <= 1) return;
    emit(
      state.copyWith(
        quantity: state.quantity - 1,
        clearAddToCartFailure: true,
        clearAddToCartSuccessMessage: true,
      ),
    );
  }

  void _setActiveProduct(String? productId) {
    emit(state.copyWith(activeProductId: productId));
  }

  Future<void> _addToCart() async {
    final productDetails = state.productDetails;
    if (state.isAddingToCart || productDetails == null) return;

    if (productDetails.masterProductId.isEmpty) {
      emit(
        state.copyWith(
          addToCartFailure: const Failure(
            errorMessage: 'Product id is unavailable for this item.',
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isAddingToCart: true,
        clearAddToCartFailure: true,
        clearAddToCartSuccessMessage: true,
      ),
    );

    final request = AddCartItemRequestEntity(
      productId: productDetails.masterProductId,
      quantity: state.quantity,
    );

    final result = await _addCartItemUseCase.call(request);
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        await _guestCartSyncService.cacheGuestCartItem(request);
        _cartCountSyncService.incrementBy(request.quantity);
        emit(
          state.copyWith(
            isAddingToCart: false,
            addToCartSuccessMessage: result.data.message.isNotEmpty
                ? result.data.message
                : _l10n.product_added_to_cart(state.quantity, productDetails.name),
            clearAddToCartFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isAddingToCart: false,
            addToCartFailure: result.failure,
          ),
        );
    }
  }

  void _clearFeedback() {
    emit(
      state.copyWith(
        clearAddToCartFailure: true,
        clearAddToCartSuccessMessage: true,
      ),
    );
  }

  Future<void> _loadInitialCartCount() async {
    final result = await _getCartUseCase.call();
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(cartCount: result.data.summary.totalQuantity));
      case ApiErrorResult():
        developer.log(
          'Loading cart count failed: ${result.failure.errorMessage}',
          name: 'ProductDetailsCubit',
        );
        break;
    }
  }

  void _attachCartListenerIfNeeded() {
    if (_isCartListenerAttached) return;
    _cartCountSyncService.addListener(_handleCartCountChanged);
    _isCartListenerAttached = true;
  }

  void _handleCartCountChanged() {
    final absoluteCount = _cartCountSyncService.absoluteCount;
    if (absoluteCount != null) {
      emit(state.copyWith(cartCount: math.max(0, absoluteCount)));
      return;
    }

    if (_cartCountSyncService.refreshRequested) {
      _loadInitialCartCount();
      return;
    }

    emit(
      state.copyWith(
        cartCount: math.max(0, state.cartCount + _cartCountSyncService.delta),
      ),
    );
  }

  @override
  Future<void> close() {
    if (_isCartListenerAttached) {
      _cartCountSyncService.removeListener(_handleCartCountChanged);
    }
    return super.close();
  }
}
