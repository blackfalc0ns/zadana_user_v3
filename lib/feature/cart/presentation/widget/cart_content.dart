import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_vendor_entity.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_animations.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_item_card.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_prompt_card.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_selector.dart';

class CartContent extends StatefulWidget {
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
    required this.onLoadMore,
    this.isLoadingMore = false,
    this.hasMore = false,
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
  final VoidCallback onLoadMore;
  final bool isLoadingMore;
  final bool hasMore;
  final String? activeHeroProductId;
  final String? animatingPriceItemId;

  @override
  State<CartContent> createState() => _CartContentState();
}

class _CartContentState extends State<CartContent> {
  static const double _loadMoreThreshold = 320;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    if (position.extentAfter <= _loadMoreThreshold &&
        widget.hasMore &&
        !widget.isLoadingMore) {
      widget.onLoadMore();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.selectedVendorId != null && widget.unavailableCount > 0)
          _buildUnavailableWarning(context, widget.unavailableCount),
        if (widget.selectedVendorId == null) _buildSelectVendorPrompt(),
        VendorSelector(
          vendors: widget.vendors,
          selectedVendorId: widget.selectedVendorId,
          onVendorSelected: widget.onVendorSelected,
        ),
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

  Widget _buildSelectVendorPrompt() {
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
       padding: const EdgeInsets.symmetric(horizontal:Spacing.screenH),
        child: const VendorPromptCard(),
      ),
    );
  }

  Widget _buildItemsList() {
    final itemCount = widget.items.length + (widget.isLoadingMore ? 1 : 0);

    return ListView.separated(
      controller: _scrollController,
      key: const PageStorageKey<String>('cart_items_list'),
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: 5),
      itemBuilder: (_, index) {
        if (index >= widget.items.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        return CartItemCard(
          item: widget.items[index],
          selectedVendorId: widget.selectedVendorId,
          loadedVendorId: widget.loadedVendorId,
          isLoadingSelectedVendorPrices: widget.isLoadingSelectedVendorPrices,
          priceAnimationVersion: widget.priceAnimationVersion,
          onTap: () => widget.onItemTap(widget.items[index]),
          onIncrement: () => widget.onUpdateQuantity(widget.items[index], true),
          onDecrement: () => widget.onUpdateQuantity(widget.items[index], false),
          onDelete: () => widget.onDeleteItem(widget.items[index]),
          enableHeroAnimation: widget.activeHeroProductId == widget.items[index].id,
          animatePrice:
              widget.selectedVendorId != null && widget.items[index].id == widget.animatingPriceItemId,
        );
      },
    );
  }
}
