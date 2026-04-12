import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/cart/presentation/manager/cart_event.dart';
import 'package:zadana_user_v3/feature/cart/presentation/manager/cart_state.dart';
import 'package:zadana_user_v3/feature/cart/presentation/manager/cart_view_model.dart';
import 'package:zadana_user_v3/feature/cart/presentation/pages/cart_screen_mixin.dart';
import 'package:zadana_user_v3/feature/cart/presentation/pages/cart_screen_view_data.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_app_bar.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_screen_body.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = getIt<CartViewModel>();

    return BlocProvider(
      create: (_) => viewModel
        ..doIntent(const CartLoadVendorsEvent())
        ..doIntent(const CartLoadItemsEvent()),
      child: const _CartScreenView(),
    );
  }
}

class _CartScreenView extends StatefulWidget {
  const _CartScreenView();

  @override
  State<_CartScreenView> createState() => _CartScreenViewState();
}

class _CartScreenViewState extends State<_CartScreenView>
    with TickerProviderStateMixin, CartScreenMixin {
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return BlocConsumer<CartViewModel, CartState>(
      listenWhen: (previous, current) =>
          previous.isLoadingItems != current.isLoadingItems ||
          previous.loadedVendorId != current.loadedVendorId ||
          previous.clearCartSuccessMessage != current.clearCartSuccessMessage ||
          previous.clearCartErrorMessage != current.clearCartErrorMessage ||
          previous.removeItemSuccessMessage !=
              current.removeItemSuccessMessage ||
          previous.removeItemErrorMessage != current.removeItemErrorMessage ||
          previous.updateQuantityErrorMessage !=
              current.updateQuantityErrorMessage,
      listener: (_, state) => handleStateChanges(state),
      builder: (context, state) {
        final screenData = CartScreenViewData.fromState(
          state: state,
          localization: context.localization,
          selectedVendorId: selectedVendorId,
          isRefreshingSelectedVendorPrices: isRefreshingSelectedVendorPrices,
        );

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: color.surface,
            appBar: CartAppBar(
              itemCount: screenData.items.length,
              totalQuantity: screenData.totalQuantity,
              onClearAll: screenData.isEmpty ? null : showClearDialog,
            ),
            body: RefreshIndicator(
              onRefresh: refreshCart,
              child: CartScreenBody(
                state: state,
                viewData: screenData,
                selectedVendorId: selectedVendorId,
                priceAnimationVersion: priceAnimationVersion,
                activeHeroProductId: activeHeroProductId,
                animatingPriceItemId: animatingPriceItemId,
                animations: animations,
                onRetry: reloadCartData,
                onVendorSelected: onVendorSelected,
                onItemTap: openProductDetails,
                onUpdateQuantity: updateQuantity,
                onDeleteItem: showDeleteDialog,
                onComparison: showComparison,
                onCheckout: onCheckout,
              ),
            ),
          ),
        );
      },
    );
  }
}
