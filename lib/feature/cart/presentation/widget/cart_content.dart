import 'package:flutter/material.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_selector.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_item_card.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_prompt_card.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_animations.dart';

class CartContent extends StatelessWidget {
  final List<CartItemModel> items;
  final String? selectedVendorId;
  final Function(String) onVendorSelected;
  final Function(CartItemModel, bool) onUpdateQuantity;
  final Function(CartItemModel) onDeleteItem;

  const CartContent({
    super.key,
    required this.items,
    required this.selectedVendorId,
    required this.onVendorSelected,
    required this.onUpdateQuantity,
    required this.onDeleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VendorSelector(
          vendors: dummyVendors,
          selectedVendorId: selectedVendorId,
          onVendorSelected: onVendorSelected,
        ),
        if (selectedVendorId == null) _buildSelectVendorPrompt(),
        const Divider(height: 4),
        Expanded(child: _buildItemsList()),
      ],
    );
  }

  Widget _buildSelectVendorPrompt() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return CartAnimations.buildVendorPromptTransition(
          child: child,
          animation: animation,
        );
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: VendorPromptCard(),
      ),
    );
  }

  Widget _buildItemsList() {
    return ListView.separated(
      key: ValueKey('items_list_${selectedVendorId ?? "no_vendor"}'),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      itemCount: items.length,
      separatorBuilder: (_, index) => const SizedBox(height: 3.0),
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: CartItemCard(
          item: items[index],
          selectedVendorId: selectedVendorId,
          onIncrement: () => onUpdateQuantity(items[index], true),
          onDecrement: () => onUpdateQuantity(items[index], false),
          onDelete: () => onDeleteItem(items[index]),
        ),
      ),
    );
  }
}
