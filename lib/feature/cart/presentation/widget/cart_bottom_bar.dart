import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/formatters/price_formatter.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_animations.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/select_vendor_bar.dart';

class CartBottomBar extends StatelessWidget {
  final String? selectedVendorId;
  final List<CartItemModel> items;
  final double totalPrice;
  final double totalOldPrice;
  final double totalSavings;
  final bool hasDiscounts;
  final String selectedVendorName;
  final CartAnimations animations;
  final VoidCallback onComparison;
  final VoidCallback onCheckout;

  const CartBottomBar({
    super.key,
    required this.selectedVendorId,
    required this.items,
    required this.totalPrice,
    required this.totalOldPrice,
    required this.totalSavings,
    required this.hasDiscounts,
    required this.selectedVendorName,
    required this.animations,
    required this.onComparison,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return CartAnimations.buildBottomBarTransition(
          child: child,
          animation: animation,
        );
      },
      child: selectedVendorId == null
          ? SelectVendorBar(items: items)
          : _SelectedVendorBar(
              key: ValueKey('selected_bottom_$selectedVendorId'),
              selectedVendorId: selectedVendorId!,
              items: items,
              totalPrice: totalPrice,
              totalOldPrice: totalOldPrice,
              totalSavings: totalSavings,
              hasDiscounts: hasDiscounts,
              selectedVendorName: selectedVendorName,
              animations: animations,
              onComparison: onComparison,
              onCheckout: onCheckout,
            ),
    );
  }
}

class _SelectedVendorBar extends StatelessWidget {
  const _SelectedVendorBar({
    super.key,
    required this.selectedVendorId,
    required this.items,
    required this.totalPrice,
    required this.totalOldPrice,
    required this.totalSavings,
    required this.hasDiscounts,
    required this.selectedVendorName,
    required this.animations,
    required this.onComparison,
    required this.onCheckout,
  });

  final String selectedVendorId;
  final List<CartItemModel> items;
  final double totalPrice;
  final double totalOldPrice;
  final double totalSavings;
  final bool hasDiscounts;
  final String selectedVendorName;
  final CartAnimations animations;
  final VoidCallback onComparison;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Vendor info row + price ──
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.12),
                      AppColors.primaryLight.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.storefront_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedVendorName,
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size13,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${items.length} ${locale.product}',
                      style: getMediumStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // ── Price badge ──
              AnimatedBuilder(
                animation: animations.priceSlideAnimation,
                builder: (context, child) {
                  return SlideTransition(
                    position: animations.priceSlideAnimation,
                    child: FadeTransition(
                      opacity: animations.priceFadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Text(
                          '${PriceFormatter.formatPrice(totalPrice)} ${locale.currency}',
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            color: AppColors.primary,
                            fontSize: FontSize.size12,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          // ── Action buttons row ──
          Row(
            children: [
              // Checkout button
              Expanded(
                flex: 3,
                child: _CartCheckoutButton(
                  onTap: onCheckout,
                  label: locale.checkout,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CartCheckoutButton extends StatelessWidget {
  const _CartCheckoutButton({required this.onTap, required this.label});

  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          height: 36,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                size: 16,
                color: AppColors.white,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size12,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
