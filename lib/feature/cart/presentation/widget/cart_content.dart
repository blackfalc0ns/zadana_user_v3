import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_vendor_entity.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_animations.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_item_card.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_selector.dart';

class CartContent extends StatelessWidget {
  const CartContent({
    super.key,
    required this.items,
    required this.vendors,
    required this.selectedVendorId,
    required this.loadedVendorId,
    required this.isLoadingSelectedVendorPrices,
    required this.unavailableCount,
    required this.priceAnimationVersion,
    required this.onVendorSelected,
    required this.onItemTap,
    required this.onUpdateQuantity,
    required this.onDeleteItem,
    this.activeHeroProductId,
    this.animatingPriceItemId,
  });

  final List<CartItemModel> items;
  final List<CartVendorEntity> vendors;
  final String? selectedVendorId;
  final String? loadedVendorId;
  final bool isLoadingSelectedVendorPrices;
  final int unavailableCount;
  final int priceAnimationVersion;
  final Function(String) onVendorSelected;
  final Function(CartItemModel) onItemTap;
  final Function(CartItemModel, bool) onUpdateQuantity;
  final Function(CartItemModel) onDeleteItem;
  final String? activeHeroProductId;
  final String? animatingPriceItemId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (selectedVendorId != null && unavailableCount > 0)
          _buildUnavailableWarning(context, unavailableCount),
        VendorSelector(
          vendors: vendors,
          selectedVendorId: selectedVendorId,
          onVendorSelected: onVendorSelected,
        ),
        if (selectedVendorId == null) _buildSelectVendorPrompt(context),
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 14),
          color: AppColors.divider.withValues(alpha: 0.5),
        ),
        Expanded(child: _buildItemsList()),
      ],
    );
  }

  Widget _buildUnavailableWarning(BuildContext context, int count) {
    final locale = context.localization;

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 6, 14, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.24)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.warning, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locale.cart_unavailable_products_title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  locale.cart_unavailable_products_message(count),
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
        margin: const EdgeInsets.fromLTRB(14, 6, 14, 6),
        padding: const EdgeInsets.all(10),
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.store_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.select_vendor_to_show_price,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    locale.select_vendors_to_compare,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.touch_app_rounded,
              color: AppColors.primary.withValues(alpha: 0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    return ListView.separated(
      key: const PageStorageKey<String>('cart_items_list'),
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 5),
      itemBuilder: (_, index) => CartItemCard(
        item: items[index],
        selectedVendorId: selectedVendorId,
        loadedVendorId: loadedVendorId,
        isLoadingSelectedVendorPrices: isLoadingSelectedVendorPrices,
        priceAnimationVersion: priceAnimationVersion,
        onTap: () => onItemTap(items[index]),
        onIncrement: () => onUpdateQuantity(items[index], true),
        onDecrement: () => onUpdateQuantity(items[index], false),
        onDelete: () => onDeleteItem(items[index]),
        enableHeroAnimation: activeHeroProductId == items[index].id,
        animatePrice:
            selectedVendorId != null && items[index].id == animatingPriceItemId,
      ),
    );
  }
}
