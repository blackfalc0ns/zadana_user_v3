import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/services/cart_navigation_service.dart';
import 'package:zadana_user_v3/core/services/checkout_flow_service.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';
import 'package:zadana_user_v3/feature/addresses/domain/usecase/get_customer_addresses_usecase.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/delivery_check_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/check_delivery_usecase.dart';
import 'package:zadana_user_v3/feature/cart/presentation/manager/cart_event.dart';
import 'package:zadana_user_v3/feature/cart/presentation/manager/cart_state.dart';
import 'package:zadana_user_v3/feature/cart/presentation/manager/cart_view_model.dart';
import 'package:zadana_user_v3/feature/cart/presentation/pages/cart_product_mapper.dart';
import 'package:zadana_user_v3/feature/cart/presentation/pages/cart_screen_view_data.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_animations.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_dialogs.dart';

mixin CartScreenMixin<T extends StatefulWidget> on State<T>, TickerProvider
    implements WidgetsBindingObserver {
  static const Duration quantityDebounceDuration = Duration(milliseconds: 500);
  static const Duration vendorPriceAnimationDelay = Duration(milliseconds: 250);

  String? selectedVendorId;
  String? activeHeroProductId;
  String? animatingPriceItemId;
  bool isRefreshingSelectedVendorPrices = false;
  int priceAnimationVersion = 0;
  final Map<String, Timer> quantityDebouncers = {};
  final Map<String, int> pendingQuantityBaselines = {};
  late final CartViewModel viewModel;
  late final CartNavigationService cartNavigationService;
  late final CartAnimations animations;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    viewModel = context.read<CartViewModel>();
    cartNavigationService = CartNavigationService()
      ..addListener(handleCartTabChanged);
    animations = CartAnimations(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _processPendingCartNavigationRequest();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cartNavigationService.removeListener(handleCartTabChanged);
    clearPendingQuantityUpdates();
    animations.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted || state != AppLifecycleState.resumed) return;
    reloadCartData();
  }

  CartState get cartState => context.read<CartViewModel>().state;

  CartScreenViewData get viewData => CartScreenViewData.fromState(
    state: cartState,
    localization: context.localization,
    selectedVendorId: selectedVendorId,
    isRefreshingSelectedVendorPrices: isRefreshingSelectedVendorPrices,
  );

  void handleCartTabChanged() {
    final shouldClearState = _consumePendingClearStateRequest();
    final shouldReload = _consumePendingReloadRequest();

    if (shouldClearState) {
      clearPendingQuantityUpdates();
      viewModel.doIntent(const CartResetAfterCheckoutEvent());
      resetVendorSelection();
    }

    if (!shouldReload) return;

    if (!shouldClearState) {
      resetVendorSelection();
    }
    reloadCartData();
  }

  void reloadCartData() {
    viewModel
      ..doIntent(const CartLoadVendorsEvent())
      ..doIntent(const CartLoadItemsEvent());
  }

  void _processPendingCartNavigationRequest() {
    final shouldClearState = _consumePendingClearStateRequest();
    final shouldReload = _consumePendingReloadRequest();

    if (!shouldClearState && !shouldReload) return;

    if (shouldClearState) {
      clearPendingQuantityUpdates();
      viewModel.doIntent(const CartResetAfterCheckoutEvent());
      resetVendorSelection();
    }

    if (!shouldReload) return;

    if (!shouldClearState) {
      resetVendorSelection();
    }
    reloadCartData();
  }

  bool _consumePendingClearStateRequest() {
    return cartNavigationService.consumeClearStateRequest();
  }

  bool _consumePendingReloadRequest() {
    return cartNavigationService.consumeReloadRequest();
  }

  Future<void> refreshCart() async {
    viewModel
      ..doIntent(const CartRetryVendorsEvent())
      ..doIntent(const CartRetryItemsEvent());
  }

  void resetVendorSelection() {
    if (!mounted) return;
    setState(_clearSelectionState);
  }

  void _clearSelectionState() {
    selectedVendorId = null;
    activeHeroProductId = null;
    animatingPriceItemId = null;
    isRefreshingSelectedVendorPrices = false;
    priceAnimationVersion = 0;
  }

  void clearPendingQuantityUpdates() {
    for (final timer in quantityDebouncers.values) {
      timer.cancel();
    }
    quantityDebouncers.clear();
    pendingQuantityBaselines.clear();
  }

  void showSelectionRequiredMessage() {
    _showSnackBar(context.localization.select_vendor_to_show_price);
  }

  void updateQuantity(CartItemModel item, bool increment) {
    if (!increment && item.quantity <= 1) {
      showDeleteDialog(item);
      return;
    }

    final previousQuantity = item.quantity;
    final nextQuantity = increment
        ? previousQuantity + 1
        : previousQuantity - 1;
    pendingQuantityBaselines.putIfAbsent(item.id, () => previousQuantity);

    setState(() {
      item.quantity = nextQuantity;
    });

    quantityDebouncers[item.id]?.cancel();
    quantityDebouncers[item.id] = Timer(quantityDebounceDuration, () {
      if (!mounted) return;

      final baselineQuantity =
          pendingQuantityBaselines.remove(item.id) ?? previousQuantity;
      quantityDebouncers.remove(item.id);
      viewModel.doIntent(
        CartUpdateQuantityEvent(
          itemId: item.id,
          productId: item.productId,
          quantity: item.quantity,
          previousQuantity: baselineQuantity,
          vendorId: viewData.loadedVendorId,
        ),
      );
    });
  }

  void showDeleteDialog(CartItemModel item) => showDeleteItemDialog(
    context: context,
    itemName: item.name,
    onConfirm: () {
      quantityDebouncers.remove(item.id)?.cancel();
      pendingQuantityBaselines.remove(item.id);
      viewModel.doIntent(CartRemoveItemEvent(item));
    },
  );

  void showClearDialog() => showClearCartDialog(
    context: context,
    onConfirm: () {
      clearPendingQuantityUpdates();
      viewModel.doIntent(const CartClearAllEvent());
    },
  );

  Future<void> onVendorSelected(String vendorId) async {
    if (selectedVendorId == vendorId) return;

    setState(() {
      selectedVendorId = vendorId;
      animatingPriceItemId = null;
      isRefreshingSelectedVendorPrices = true;
    });

    viewModel.doIntent(CartLoadItemsEvent(vendorId: vendorId));
    await Future<void>.delayed(vendorPriceAnimationDelay);

    if (!mounted || selectedVendorId != vendorId) return;
    animations.playPriceAnimation();
  }

  Future<void> openProductDetails(CartItemModel item) async {
    final product = mapCartItemToProductModel(
      item: item,
      selectedVendorId: selectedVendorId,
      loadedVendorId: viewData.loadedVendorId,
    );

    setState(() {
      activeHeroProductId = item.id;
      animatingPriceItemId = item.id;
    });

    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;

    await ProductNavigationHelper.navigateToProductDetails(
      context,
      product,
      activeProductId: item.productId,
      heroTag: productHeroTag(item.productId, source: 'cart-item'),
    );

    if (!mounted) return;
    setState(() {
      activeHeroProductId = null;
      animatingPriceItemId = null;
    });
  }

  Future<void> onCheckout() async {
    if (selectedVendorId == null) {
      showSelectionRequiredMessage();
      return;
    }

    // Block checkout if server indicates items are unavailable at branch.
    final summary = cartState.summary;
    if (summary?.canCheckout == false || (summary?.hasUnavailableItems == true)) {
      _showSnackBar(
        summary?.checkoutBlockReason ??
            context.localization.cart_checkout_blocked_unavailable_products,
      );
      return;
    }

    final token = await getIt<TokenService>().getToken();
    if (!mounted) return;

    final isGuest = token == null || token.isEmpty;
    if (isGuest) {
      final shouldContinue = await showCheckoutRegistrationDialog(context);
      if (!mounted || shouldContinue != true) return;

      CheckoutFlowService().markPendingCheckout(vendorId: selectedVendorId);
      Navigator.pushNamed(context, AppRoutes.login);
      return;
    }

    // Pre-check delivery eligibility before entering checkout.
    final addressResult = await getIt<GetCustomerAddressesUseCase>()();
    if (!mounted) return;

    String? defaultAddressId;
    if (addressResult case ApiSuccessResult<List<CustomerAddressEntity>>()) {
      final defaultAddress = addressResult.data.where((a) => a.isDefault);
      if (defaultAddress.isNotEmpty) {
        defaultAddressId = defaultAddress.first.id;
      } else if (addressResult.data.isNotEmpty) {
        defaultAddressId = addressResult.data.first.id;
      }
    }

    if (defaultAddressId != null) {
      final deliveryResult = await getIt<CheckDeliveryUseCase>()(
        vendorId: selectedVendorId!,
        addressId: defaultAddressId,
      );
      if (!mounted) return;

      if (deliveryResult case ApiSuccessResult<DeliveryCheckEntity>()) {
        if (!deliveryResult.data.canProceedToCheckout) {
          final message = deliveryResult.data.messageAr.isNotEmpty
              ? deliveryResult.data.messageAr
              : deliveryResult.data.messageEn;
          showDeliveryUnavailableDialog(context: context, message: message);
          return;
        }
      }
    }

    Navigator.pushNamed(context, AppRoutes.payment, arguments: selectedVendorId);
  }

  void _resetUiAfterCartEmptied({bool resetPriceAnimationVersion = false}) {
    setState(() {
      selectedVendorId = null;
      activeHeroProductId = null;
      animatingPriceItemId = null;
      isRefreshingSelectedVendorPrices = false;
      if (resetPriceAnimationVersion) {
        priceAnimationVersion = 0;
      }
    });
  }

  void _handleClearCartSuccess(CartState state) {
    clearPendingQuantityUpdates();
    _resetUiAfterCartEmptied(resetPriceAnimationVersion: true);
    CustomSnackbar.showSuccess(
      context: context,
      message: state.clearCartSuccessMessage!,
    );
    viewModel.clearCartFeedback();
  }

  void _handleRemoveItemSuccess(CartState state) {
    quantityDebouncers.remove(state.removedItemId)?.cancel();
    pendingQuantityBaselines.remove(state.removedItemId);
    if (state.items.isEmpty) {
      _resetUiAfterCartEmptied();
    }
    CustomSnackbar.showSuccess(
      context: context,
      message: state.removeItemSuccessMessage!,
    );
    viewModel.clearRemoveItemFeedback();
  }

  void _handleErrorMessage({
    required String message,
    required VoidCallback clearFeedback,
  }) {
    CustomSnackbar.showError(context: context, message: message);
    clearFeedback();
  }

  void _showSnackBar(String message) {
    final color = context.colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      ),
    );
  }

  void handleStateChanges(CartState state) {
    if (!mounted) return;

    final hasUpdatedSelectedVendorPrices =
        state.loadedVendorId == selectedVendorId &&
        state.loadedVendorId != null &&
        !state.isLoadingItems;
    if (hasUpdatedSelectedVendorPrices) {
      setState(() {
        isRefreshingSelectedVendorPrices = false;
        priceAnimationVersion++;
      });
      animations.playPriceAnimation();
    }

    if (state.clearCartSuccessMessage != null) {
      _handleClearCartSuccess(state);
    }

    if (state.clearCartErrorMessage != null) {
      _handleErrorMessage(
        message: state.clearCartErrorMessage!,
        clearFeedback: viewModel.clearCartFeedback,
      );
    }

    if (state.removeItemSuccessMessage != null) {
      _handleRemoveItemSuccess(state);
    }

    if (state.removeItemErrorMessage != null) {
      _handleErrorMessage(
        message: state.removeItemErrorMessage!,
        clearFeedback: viewModel.clearRemoveItemFeedback,
      );
    }

    if (state.updateQuantityErrorMessage != null) {
      _handleErrorMessage(
        message: state.updateQuantityErrorMessage!,
        clearFeedback: viewModel.clearUpdateQuantityFeedback,
      );
      pendingQuantityBaselines.remove(state.updatedQuantityItemId);
    }

    if (!state.isLoadingItems && isRefreshingSelectedVendorPrices) {
      setState(() {
        isRefreshingSelectedVendorPrices = false;
      });
    }
  }
}
