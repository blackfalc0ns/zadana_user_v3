import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_details_entity.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_variant_option_entity.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_vendor_price_entity.dart';

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
    this.selectedVariantId,
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
  final String? selectedVariantId;

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
    String? selectedVariantId,
    bool clearLoadFailure = false,
    bool clearAddToCartFailure = false,
    bool clearAddToCartSuccessMessage = false,
    bool clearSelectedVariantId = false,
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
      selectedVariantId: clearSelectedVariantId
          ? null
          : selectedVariantId ?? this.selectedVariantId,
    );
  }

  bool get hasLoadedProduct => productDetails != null;
  bool get isInitialLoading => isLoading && !hasLoadedProduct;

  /// Returns the currently selected variant, or the one marked as `isCurrent`.
  ProductVariantOptionEntity? get selectedVariant {
    final options = productDetails?.variantOptions;
    if (options == null || options.isEmpty) return null;

    if (selectedVariantId != null) {
      final match = options.where((v) => v.id == selectedVariantId).firstOrNull;
      if (match != null) return match;
    }

    return options.where((v) => v.isCurrent).firstOrNull;
  }

  /// The product ID to use when adding to cart.
  /// If a variant is selected, use its ID (each variant is a separate MasterProduct).
  /// Otherwise fall back to the product's masterProductId.
  String get effectiveProductIdForCart {
    final variant = selectedVariant;
    if (variant != null && variant.id.isNotEmpty) return variant.id;
    return productDetails?.masterProductId ?? '';
  }

  /// Resolved image URL considering the selected variant.
  String get effectiveImageUrl {
    final variant = selectedVariant;
    if (variant != null &&
        variant.imageUrl != null &&
        variant.imageUrl!.isNotEmpty) {
      return variant.imageUrl!;
    }
    return productDetails?.imageUrl ?? '';
  }

  /// Resolved images list considering the selected variant.
  List<String> get effectiveImages {
    final variant = selectedVariant;
    if (variant != null && variant.images.isNotEmpty) {
      return variant.images;
    }
    return productDetails?.images ?? const [];
  }

  /// Resolved price considering the selected variant.
  double get effectivePrice {
    final variant = selectedVariant;
    if (variant != null && variant.price != null) {
      return variant.price!;
    }
    return productDetails?.price ?? 0;
  }

  /// Resolved old price considering the selected variant.
  double? get effectiveOldPrice {
    final variant = selectedVariant;
    if (variant != null) return variant.oldPrice;
    return productDetails?.oldPrice;
  }

  /// Resolved isDiscounted considering the selected variant.
  bool get effectiveIsDiscounted {
    final variant = selectedVariant;
    if (variant != null) return variant.isDiscounted;
    return productDetails?.isDiscounted ?? false;
  }

  /// Resolved unit label considering the selected variant.
  String? get effectiveUnit {
    final variant = selectedVariant;
    if (variant != null && variant.unit != null && variant.unit!.isNotEmpty) {
      return variant.unit;
    }
    return productDetails?.unit;
  }

  List<ProductVendorPriceEntity> get effectiveVendorPrices {
    final variant = selectedVariant;
    if (variant != null && variant.vendorPrices.isNotEmpty) {
      return variant.vendorPrices;
    }
    return productDetails?.vendorPrices ?? const [];
  }

  /// Variant options with `isCurrent` updated to reflect the selected variant.
  List<ProductVariantOptionEntity> get resolvedVariantOptions {
    final options = productDetails?.variantOptions;
    if (options == null || options.isEmpty) return const [];
    if (selectedVariantId == null) return options;

    return options
        .map((v) => v.copyWith(isCurrent: v.id == selectedVariantId))
        .toList();
  }

  /// Whether the product is available for purchase.
  bool get isAvailableForPurchase =>
      productDetails?.isAvailableForPurchase ?? true;

  /// The reason the product is unavailable (if any).
  String? get unavailableReason => productDetails?.unavailableReason;

  /// Returns a user-facing message for the unavailability reason.
  String get unavailableMessage {
    switch (unavailableReason) {
      case 'vendor_offline':
        return 'المتجر غير متاح حاليًا';
      case 'outside_working_hours':
        return 'المتجر مغلق الآن خارج ساعات العمل';
      case 'accept_orders_disabled':
        return 'المتجر لا يستقبل طلبات الآن';
      case 'vendor_inactive':
        return 'هذا المتجر غير متاح حاليًا';
      default:
        return 'هذا المنتج غير متاح للشراء حاليًا';
    }
  }
}
