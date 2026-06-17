import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/app_section/page/main_shell.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/presentation/manager/cart_state.dart';
import 'package:zadana_user_v3/feature/cart/presentation/pages/cart_screen_view_data.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_animations.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_empty_state.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_loading_skeleton.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_screen_content.dart';

class CartScreenBody extends StatelessWidget {
  const CartScreenBody({
    super.key,
    required this.state,
    required this.viewData,
    required this.selectedVendorId,
    required this.priceAnimationVersion,
    required this.activeHeroProductId,
    required this.animatingPriceItemId,
    required this.animations,
    required this.onRetry,
    required this.onVendorSelected,
    required this.onItemTap,
    required this.onUpdateQuantity,
    required this.onDeleteItem,
    required this.onCheckout,
  });
  static const double _cartBottomBarGap = 8.0;
  static const double _cartBottomBarReservedHeight = 144.0;

  final CartState state;
  final CartScreenViewData viewData;
  final String? selectedVendorId;
  final int priceAnimationVersion;
  final String? activeHeroProductId;
  final String? animatingPriceItemId;
  final CartAnimations animations;
  final VoidCallback onRetry;
  final ValueChanged<String> onVendorSelected;
  final ValueChanged<CartItemModel> onItemTap;
  final void Function(CartItemModel item, bool increment) onUpdateQuantity;
  final ValueChanged<CartItemModel> onDeleteItem;
  final VoidCallback onCheckout;

  bool get _showGlobalError =>
      !state.isLoadingVendors &&
      !state.isLoadingItems &&
      state.vendors.isEmpty &&
      state.items.isEmpty &&
      (state.itemsFailure ?? state.vendorsFailure) != null;

  bool get _isInitialLoading =>
      _isPristineInitialState ||
      (state.isLoadingVendors && state.vendors.isEmpty) ||
      (state.isLoadingItems && state.items.isEmpty);

  bool get _isPristineInitialState =>
      !state.isLoadingVendors &&
      !state.isLoadingItems &&
      !state.isVendorsSuccess &&
      !state.isItemsSuccess &&
      state.vendors.isEmpty &&
      state.items.isEmpty &&
      state.vendorsFailure == null &&
      state.itemsFailure == null;

  @override
  Widget build(BuildContext context) {
    if (_showGlobalError) {
      return _GlobalCartErrorState(
        failure: state.itemsFailure ?? state.vendorsFailure!,
        onRetry: onRetry,
      );
    }

    if (_isInitialLoading) {
      return const CartScrollableState(child: CartLoadingSkeleton());
    }

    if (viewData.isEmpty) {
      return CartScrollableState(
        child: CartEmptyState(
          onStartShopping: () => mainShellKey.currentState?.jumpToTab(0),
        ),
      );
    }

    final bottomNavReservedSpace = mainShellBottomNavReservedSpace(context);
    final cartBottomOffset = bottomNavReservedSpace + _cartBottomBarGap;
    final contentBottomPadding =
        cartBottomOffset + _cartBottomBarReservedHeight;

    return CartScreenContent(
      bottomOffset: cartBottomOffset,
      contentBottomPadding: contentBottomPadding,
      items: viewData.items,
      vendors: viewData.vendors,
      selectedVendorId: selectedVendorId,
      loadedVendorId: viewData.loadedVendorId,
      isLoadingSelectedVendorPrices: viewData.isLoadingSelectedVendorPrices,
      unavailableCount: viewData.unavailableCount,
      priceAnimationVersion: priceAnimationVersion,
      activeHeroProductId: activeHeroProductId,
      animatingPriceItemId: animatingPriceItemId,
      totalPrice: viewData.totalPrice,
      totalOldPrice: viewData.totalOldPrice,
      hasDiscounts: viewData.hasDiscounts,
      selectedVendorName: viewData.selectedVendorName,
      hasUnavailableItems: !viewData.canCheckout || viewData.unavailableCount > 0,
      animations: animations,
      onVendorSelected: onVendorSelected,
      onItemTap: onItemTap,
      onUpdateQuantity: onUpdateQuantity,
      onDeleteItem: onDeleteItem,
      onCheckout: onCheckout,
    );
  }
}

class _GlobalCartErrorState extends StatelessWidget {
  const _GlobalCartErrorState({required this.failure, required this.onRetry});

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: Spacing.sm)),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: ApiErrorWidget(
                exception: failure.exception,
                onRetry: onRetry,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
