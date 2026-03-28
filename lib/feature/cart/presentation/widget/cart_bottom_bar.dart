import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/formatters/price_formatter.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_animations.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/select_vendor_bar.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_selector.dart';

class CartBottomBar extends StatelessWidget {
  final String? selectedVendorId;
  final List<CartItemModel> items;
  final double totalPrice;
  final String selectedVendorName;
  final CartAnimations animations;
  final VoidCallback onComparison;
  final VoidCallback onCheckout;

  const CartBottomBar({
    super.key,
    required this.selectedVendorId,
    required this.items,
    required this.totalPrice,
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
    required this.selectedVendorName,
    required this.animations,
    required this.onComparison,
    required this.onCheckout,
  });

  final String selectedVendorId;
  final List<CartItemModel> items;
  final double totalPrice;
  final String selectedVendorName;
  final CartAnimations animations;
  final VoidCallback onComparison;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final vendor = dummyVendors.firstWhere((v) => v.id == selectedVendorId);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.12),
                      AppColors.primaryLight.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(vendor.emoji, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedVendorName,
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size14,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${items.length} ${locale.product}',
                      style: getMediumStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size12,
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
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Text(
                          '${PriceFormatter.formatPrice(totalPrice)} ${locale.currency}',
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            color: AppColors.primary,
                            fontSize: FontSize.size14,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          // ── Action buttons row ──
          Row(
            children: [
              // Compare button

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

class _CartOutlinedButton extends StatelessWidget {
  const _CartOutlinedButton({
    required this.onTap,
    required this.icon,
    required this.label,
  });

  final VoidCallback onTap;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size12,
                    color: AppColors.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
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
          height: 40,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                size: 18,
                color: AppColors.white,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
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
