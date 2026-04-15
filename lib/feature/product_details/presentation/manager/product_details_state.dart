import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_details_entity.dart';

class ProductDetailsState {
  const ProductDetailsState({
    this.isLoading = false,
    this.isAddingToCart = false,
    this.quantity = 1,
    this.cartCount = 0,
    this.productDetails,
    this.loadFailure,
    this.addToCartFailure,
    this.addToCartSuccessMessage,
    this.activeProductId,
  });

  final bool isLoading;
  final bool isAddingToCart;
  final int quantity;
  final int cartCount;
  final ProductDetailsEntity? productDetails;
  final Failure? loadFailure;
  final Failure? addToCartFailure;
  final String? addToCartSuccessMessage;
  final String? activeProductId;

  ProductDetailsState copyWith({
    bool? isLoading,
    bool? isAddingToCart,
    int? quantity,
    int? cartCount,
    ProductDetailsEntity? productDetails,
    Failure? loadFailure,
    Failure? addToCartFailure,
    String? addToCartSuccessMessage,
    String? activeProductId,
    bool clearLoadFailure = false,
    bool clearAddToCartFailure = false,
    bool clearAddToCartSuccessMessage = false,
  }) {
    return ProductDetailsState(
      isLoading: isLoading ?? this.isLoading,
      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
      quantity: quantity ?? this.quantity,
      cartCount: cartCount ?? this.cartCount,
      productDetails: productDetails ?? this.productDetails,
      loadFailure: clearLoadFailure ? null : loadFailure ?? this.loadFailure,
      addToCartFailure: clearAddToCartFailure
          ? null
          : addToCartFailure ?? this.addToCartFailure,
      addToCartSuccessMessage: clearAddToCartSuccessMessage
          ? null
          : addToCartSuccessMessage ?? this.addToCartSuccessMessage,
      activeProductId: activeProductId ?? this.activeProductId,
    );
  }

  bool get hasLoadedProduct => productDetails != null;
  bool get isInitialLoading => isLoading && !hasLoadedProduct;
}
