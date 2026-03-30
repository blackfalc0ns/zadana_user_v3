import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_selector.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_item_card.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_animations.dart';

class CartContent extends StatelessWidget {
  final List<CartItemModel> items;
  final String? selectedVendorId;
  final Function(String) onVendorSelected;
  final Function(CartItemModel) onItemTap;
  final Function(CartItemModel, bool) onUpdateQuantity;
  final Function(CartItemModel) onDeleteItem;
  final String? activeHeroProductId;
  final String? animatingPriceItemId;

  const CartContent({
    super.key,
    required this.items,
    required this.selectedVendorId,
    required this.onVendorSelected,
    required this.onItemTap,
    required this.onUpdateQuantity,
    required this.onDeleteItem,
    this.activeHeroProductId,
    this.animatingPriceItemId,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Column(
      children: [
        // ── Vendor selector ──
        VendorSelector(
          vendors: dummyVendors,
          selectedVendorId: selectedVendorId,
          onVendorSelected: onVendorSelected,
        ),

        // ── Vendor prompt (when no vendor selected) ──
        if (selectedVendorId == null) _buildSelectVendorPrompt(context),

        // ── Subtle divider ──
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          color: AppColors.divider.withValues(alpha: 0.5),
        ),

        // ── Items count header ──
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: Row(
            children: [
              Text(
                '${locale.product} (${items.length})',
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (selectedVendorId != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 14,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dummyVendors
                            .firstWhere((v) => v.id == selectedVendorId)
                            .name,
                        style: getMediumStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size11,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),

        // ── Items list ──
        Expanded(child: _buildItemsList()),
      ],
    );
  }

  Widget _buildSelectVendorPrompt(BuildContext context) {
    final locale = context.localization;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return CartAnimations.buildVendorPromptTransition(
          child: child,
          animation: animation,
        );
      },
      child: Container(
        key: const ValueKey('select_prompt'),
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.06),
              AppColors.primaryLight.withValues(alpha: 0.03),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.store_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.select_vendor_to_show_price,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    locale.select_vendors_to_compare,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.touch_app_rounded,
              color: AppColors.primary.withValues(alpha: 0.6),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    return ListView.separated(
      key: const PageStorageKey<String>('cart_items_list'),
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 6),
      itemBuilder: (_, index) => CartItemCard(
        isDiscounted: index % 2 == 0,
        item: items[index],
        selectedVendorId: selectedVendorId,
        onTap: () => onItemTap(items[index]),
        onIncrement: () => onUpdateQuantity(items[index], true),
        onDecrement: () => onUpdateQuantity(items[index], false),
        onDelete: () => onDeleteItem(items[index]),
        enableHeroAnimation: activeHeroProductId == items[index].id,
        animatePrice: selectedVendorId != null && items[index].id == animatingPriceItemId,
      ),
    );
  }
}
