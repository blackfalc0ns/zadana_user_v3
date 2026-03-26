import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_animations.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_action_buttons.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/select_vendor_bar.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_selector.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/animated_price_display.dart';

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
          : _buildSelectedVendorBottomBar(context),
    );
  }

  Widget _buildSelectedVendorBottomBar(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    
    return Container(
      key: ValueKey('selected_bottom_$selectedVendorId'),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        color: color.surface,
        // boxShadow: [
        //   BoxShadow(
        //     color: color.shadow.withValues(alpha: 0.1),
        //     blurRadius: 8,
        //     offset: const Offset(0, -2),
        //   ),
        // ],
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _buildVendorInfo(context, locale),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AnimatedPriceDisplay(
                  totalPrice: totalPrice,
                  animations: animations,
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: CartActionButtons(
                    onComparison: onComparison,
                    onCheckout: onCheckout,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorInfo(BuildContext context, locale) {
    final color = context.colorScheme;
    final vendor = dummyVendors.firstWhere((v) => v.id == selectedVendorId);
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            vendor.emoji,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedVendorName,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                  color: color.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${items.length} ${locale.product}',
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size12,
                  color: color.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
