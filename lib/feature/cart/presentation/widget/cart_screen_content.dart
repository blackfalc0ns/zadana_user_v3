import 'package:flutter/material.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_vendor_entity.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_animations.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_bottom_bar.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_content.dart';

class CartScrollableState extends StatelessWidget {
  const CartScrollableState({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [SizedBox(height: constraints.maxHeight, child: child)],
        );
      },
    );
  }
}

class CartScreenContent extends StatelessWidget {
  const CartScreenContent({
    super.key,
    required this.bottomOffset,
    required this.contentBottomPadding,
    required this.items,
    required this.vendors,
    required this.selectedVendorId,
    required this.loadedVendorId,
    required this.isLoadingSelectedVendorPrices,
    required this.priceAnimationVersion,
    required this.activeHeroProductId,
    required this.animatingPriceItemId,
    required this.totalPrice,
    required this.totalOldPrice,
    required this.hasDiscounts,
    required this.selectedVendorName,
    required this.animations,
    required this.onVendorSelected,
    required this.onItemTap,
    required this.onUpdateQuantity,
    required this.onDeleteItem,
    required this.onCheckout,
  });

  final double bottomOffset;
  final double contentBottomPadding;
  final List<CartItemModel> items;
  final List<CartVendorEntity> vendors;
  final String? selectedVendorId;
  final String? loadedVendorId;
  final bool isLoadingSelectedVendorPrices;
  final int priceAnimationVersion;
  final String? activeHeroProductId;
  final String? animatingPriceItemId;
  final double totalPrice;
  final double totalOldPrice;
  final bool hasDiscounts;
  final String selectedVendorName;
  final CartAnimations animations;
  final ValueChanged<String> onVendorSelected;
  final ValueChanged<CartItemModel> onItemTap;
  final void Function(CartItemModel item, bool increment) onUpdateQuantity;
  final ValueChanged<CartItemModel> onDeleteItem;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(bottom: contentBottomPadding),
            child: CartContent(
              items: items,
              vendors: vendors,
              selectedVendorId: selectedVendorId,
              loadedVendorId: loadedVendorId,
              isLoadingSelectedVendorPrices: isLoadingSelectedVendorPrices,
              priceAnimationVersion: priceAnimationVersion,
              activeHeroProductId: activeHeroProductId,
              animatingPriceItemId: animatingPriceItemId,
              onVendorSelected: onVendorSelected,
              onItemTap: onItemTap,
              onUpdateQuantity: onUpdateQuantity,
              onDeleteItem: onDeleteItem,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: bottomOffset,
          child: CartBottomBar(
            selectedVendorId: selectedVendorId,
            items: items,
            totalPrice: totalPrice,
            totalOldPrice: totalOldPrice,
            hasDiscounts: hasDiscounts,
            selectedVendorName: selectedVendorName,
            animations: animations,
            onCheckout: onCheckout,
          ),
        ),
      ],
    );
  }
}
