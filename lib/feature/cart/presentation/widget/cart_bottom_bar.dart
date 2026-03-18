import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_animations.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_info_row.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_action_buttons.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/select_vendor_bar.dart';

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
          : _buildSelectedVendorBottomBar(),
    );
  }

  Widget _buildSelectedVendorBottomBar() {
    return Container(

      key: ValueKey('selected_bottom_$selectedVendorId'),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VendorInfoRow(
            selectedVendorId: selectedVendorId!,
            selectedVendorName: selectedVendorName,
            itemsCount: items.length,
            totalPrice: totalPrice,
            animations: animations,
          ),
          const SizedBox(height: 8),
          CartActionButtons(
            onComparison: onComparison,
            onCheckout: onCheckout,
          ),
        ],
      ),
    );
  }
}