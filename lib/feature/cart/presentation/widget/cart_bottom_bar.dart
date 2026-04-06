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
    final vendor = dummyVendors.firstWhere((v) => v.id == selectedVendorId);

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
                child: Text(vendor.emoji, style: const TextStyle(fontSize: 17)),
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

  Widget _buildPriceSection(BuildContext context) {
    final locale = context.localization;

    // If there are discounts, show old price and savings
    if (hasDiscounts) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Prices column
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Old price (strikethrough)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    PriceFormatter.formatPrice(totalOldPrice),
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size11,
                      color: AppColors.textSecondary,
                    ).copyWith(
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColors.textSecondary.withValues(alpha: 0.5),
                      decorationThickness: 2,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    locale.currency,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size9,
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              // New price (bold)
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    PriceFormatter.formatPrice(totalPrice),
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      color: AppColors.success,
                      fontSize: FontSize.size16,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    locale.currency,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      color: AppColors.success.withValues(alpha: 0.8),
                      fontSize: FontSize.size11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 8),
          // Savings badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_down_rounded, size: 12, color: AppColors.white),
                const SizedBox(width: 3),
                Text(
                  PriceFormatter.formatPrice(totalSavings),
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size11,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  locale.currency,
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size8,
                    color: AppColors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // No discounts - show regular price
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primaryLight.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            PriceFormatter.formatPrice(totalPrice),
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              color: AppColors.primary,
              fontSize: FontSize.size16,
            ),
          ),
          const SizedBox(width: 3),
          Text(
            locale.currency,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              color: AppColors.primary.withValues(alpha: 0.8),
              fontSize: FontSize.size11,
            ),
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
