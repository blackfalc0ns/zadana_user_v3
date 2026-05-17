import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/core/services/language_service.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/add_cart_item_request_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/repo/cart_repository.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/add_cart_item_usecase.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_details_entity.dart';
import 'package:zadana_user_v3/feature/product_details/domain/usecase/product_details_usecase.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/manager/product_details_event.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/manager/product_details_state.dart';

@injectable
class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit({
    required ProductDetailsUseCase productDetailsUseCase,
    required AddCartItemUseCase addCartItemUseCase,
    required LanguageService languageService,
  }) : _productDetailsUseCase = productDetailsUseCase,
       _addCartItemUseCase = addCartItemUseCase,
       _languageService = languageService,
       super(const ProductDetailsState());

  final ProductDetailsUseCase _productDetailsUseCase;
  final AddCartItemUseCase _addCartItemUseCase;
  final LanguageService _languageService;
  final CartRepository _cartRepository = GetIt.instance<CartRepository>();

  String? _productId;
  StreamSubscription<CartMutationEvent>? _cartMutationSubscription;

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
      case SelectVariantEvent():
        _selectVariant(event.variantId);
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
  }

  Future<void> _loadProductDetails() async {
    final productId = _productId;
    if (productId == null || productId.isEmpty) return;

    emit(state.copyWith(isLoading: true, clearLoadFailure: true));

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
        emit(state.copyWith(isLoading: false, loadFailure: result.failure));
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

  void _selectVariant(String variantId) {
    emit(state.copyWith(selectedVariantId: variantId));
  }

  Future<void> _addToCart() async {
    final productDetails = state.productDetails;
    if (state.isAddingToCart || productDetails == null) return;

    final productId = state.effectiveProductIdForCart;
    if (productId.isEmpty) {
      emit(
        state.copyWith(
          addToCartFailure: Failure(
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
      productId: productId,
      quantity: state.quantity,
    );

    final result = await _addCartItemUseCase.call(request);
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isAddingToCart: false,
            addToCartSuccessMessage: result.data.message.isNotEmpty
                ? result.data.message
                : _l10n.product_added_to_cart(
                    state.quantity,
                    productDetails.name,
                  ),
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

  void _attachCartListenerIfNeeded() {
    _cartMutationSubscription ??= _cartRepository.mutations.listen(
      _handleCartMutation,
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
  }

  @override
  Future<void> close() async {
    await _cartMutationSubscription?.cancel();
    return super.close();
  }
}
