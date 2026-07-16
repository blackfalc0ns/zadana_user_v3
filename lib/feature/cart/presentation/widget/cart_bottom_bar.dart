import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/formatters/price_formatter.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_animations.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/select_vendor_bar.dart';

class CartBottomBar extends StatelessWidget {
  const CartBottomBar({
    super.key,
    required this.selectedVendorId,
    required this.items,
    required this.totalPrice,
    required this.totalOldPrice,
    required this.hasDiscounts,
    required this.selectedVendorName,
    required this.hasUnavailableItems,
    required this.animations,
    required this.onCheckout,
  });
  final String? selectedVendorId;
  final List<CartItemModel> items;
  final double totalPrice;
  final double totalOldPrice;
  final bool hasDiscounts;
  final String selectedVendorName;
  final bool hasUnavailableItems;
  final CartAnimations animations;
  final VoidCallback onCheckout;

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
              hasDiscounts: hasDiscounts,
              selectedVendorName: selectedVendorName,
              hasUnavailableItems: hasUnavailableItems,
              animations: animations,
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
    required this.hasDiscounts,
    required this.selectedVendorName,
    required this.hasUnavailableItems,
    required this.animations,
    required this.onCheckout,
  });

  final String selectedVendorId;
  final List<CartItemModel> items;
  final double totalPrice;
  final double totalOldPrice;
  final bool hasDiscounts;
  final String selectedVendorName;
  final bool hasUnavailableItems;
  final CartAnimations animations;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                        fontSize: FontSize.size11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
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
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${PriceFormatter.formatPrice(totalPrice)} ${locale.currency}',
                              style: getBoldStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size15,
                                color: AppColors.primary,
                              ),
                            ),
                            if (hasDiscounts && totalOldPrice > totalPrice) ...[
                              const SizedBox(height: 1),
                              Text(
                                '${PriceFormatter.formatPrice(totalOldPrice)} ${locale.currency}',
                                style:
                                    getMediumStyle(
                                      fontFamily: FontConstant.cairo,
                                      color: AppColors.textSecondary.withValues(
                                        alpha: 0.75,
                                      ),
                                      fontSize: FontSize.size11,
                                    ).copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: AppColors.textSecondary
                                          .withValues(alpha: 0.55),
                                      decorationThickness: 1.2,
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (hasUnavailableItems) ...[
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.22),
                ),
              ),
              child: Text(
                locale.cart_checkout_unavailable_hint,
                textAlign: TextAlign.center,
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size11,
                  color: AppColors.warning,
                ),
              ),
            ),
          ],
          Row(
            children: [
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

  final VoidCallback? onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          height: 48,
          decoration: BoxDecoration(
            gradient: isEnabled
                ? const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                  )
                : null,
            color: isEnabled
                ? null
                : AppColors.disabled.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: (isEnabled ? AppColors.primary : AppColors.disabled)
                    .withValues(alpha: 0.22),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 18,
                color: isEnabled
                    ? AppColors.white
                    : AppColors.textSecondary.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size15,
                  color: isEnabled
                      ? AppColors.white
                      : AppColors.textSecondary.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
