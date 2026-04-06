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
    final unavailableCount = selectedVendorId == null
        ? 0
        : items.where((item) => !item.isAvailableAt(selectedVendorId!)).length;

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

        // ── Unavailable items warning ──
        if (selectedVendorId != null && unavailableCount > 0)
          _buildUnavailableWarning(context, unavailableCount),

        // ── Subtle divider ──
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 14),
          color: AppColors.divider.withValues(alpha: 0.5),
        ),

        // ── Items count header ──
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
        //   child: Row(
        //     children: [
        //       Text(
        //         '${locale.product} (${items.length})',
        //         style: getSemiBoldStyle(
        //           fontFamily: FontConstant.cairo,
        //           fontSize: FontSize.size13,
        //           color: AppColors.textPrimary,
        //         ),
        //       ),
        //       const Spacer(),
        //       if (selectedVendorId != null)
        //         Container(
        //           padding: const EdgeInsets.symmetric(
        //             horizontal: 8,
        //             vertical: 2,
        //           ),
        //           decoration: BoxDecoration(
        //             color: unavailableCount > 0
        //                 ? AppColors.warning.withValues(alpha: 0.1)
        //                 : AppColors.success.withValues(alpha: 0.1),
        //             borderRadius: BorderRadius.circular(8),
        //           ),
        //           child: Row(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               Icon(
        //                 unavailableCount > 0
        //                     ? Icons.warning_amber_rounded
        //                     : Icons.check_circle_outline,
        //                 size: 12,
        //                 color: unavailableCount > 0
        //                     ? AppColors.warning
        //                     : AppColors.success,
        //               ),
        //               const SizedBox(width: 4),
        //               Text(
        //                 dummyVendors
        //                     .firstWhere((v) => v.id == selectedVendorId)
        //                     .name,
        //                 style: getMediumStyle(
        //                   fontFamily: FontConstant.cairo,
        //                   fontSize: FontSize.size10,
        //                   color: unavailableCount > 0
        //                       ? AppColors.warning
        //                       : AppColors.success,
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //     ],
        //   ),
        // ),

        // ── Items list ──
        Expanded(child: _buildItemsList()),
      ],
    );
  }

  Widget _buildUnavailableWarning(BuildContext context, int count) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 6, 14, 0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.warning, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'منتجات غير متوفرة',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size12,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '$count من المنتجات غير متوفرة في هذا المتجر',
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size10,
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
              child: Icon(
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
                      fontSize: FontSize.size12,
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
        isDiscounted: index % 2 == 0,
        item: items[index],
        selectedVendorId: selectedVendorId,
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
