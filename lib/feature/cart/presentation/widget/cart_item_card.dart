import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/widgets/product_image.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';

class CartItemCard extends StatefulWidget {
  final CartItemModel item;
  final String? selectedVendorId;
  final VoidCallback onTap;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;
  final bool enableHeroAnimation;

  const CartItemCard({
    super.key,
    required this.item,
    required this.selectedVendorId,
    required this.onTap,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
    this.enableHeroAnimation = false,
  });

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard>
    with TickerProviderStateMixin {
  late AnimationController _priceAnimationController;
  late Animation<Offset> _priceSlideAnimation;
  late Animation<double> _priceFadeAnimation;

  @override
  void initState() {
    super.initState();

    _priceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _priceSlideAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _priceAnimationController,
            curve: Curves.easeOutBack,
          ),
        );

    _priceFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _priceAnimationController, curve: Curves.easeOut),
    );

    if (widget.selectedVendorId != null) {
      _priceAnimationController.forward();
    }
  }

  @override
  void didUpdateWidget(CartItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedVendorId != widget.selectedVendorId &&
        widget.selectedVendorId != null) {
      _priceAnimationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _priceAnimationController.dispose();
    super.dispose();
  }

  double? get _currentPrice {
    if (widget.selectedVendorId == null) return null;

    try {
      return widget.item.vendorPrices
          .firstWhere((v) => v.id == widget.selectedVendorId)
          .price;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: color.outline.withValues(alpha: 0.12)),
          color: color.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.shadow.withValues(alpha: 0.06),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ProductImage(
              emoji: widget.item.imageUrl,
              url: '',
              width: 80,
              height: 80,
              borderRadius: Spacing.cardRadius,
              heroTag: widget.enableHeroAnimation
                  ? productHeroTag(widget.item.id)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.name,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildAnimatedPrice(locale, color),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildButton(Icons.remove, widget.onDecrement),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: color.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${widget.item.quantity}',
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size14,
                            color: color.onSurface,
                          ),
                        ),
                      ),
                      _buildButton(Icons.add, widget.onIncrement),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: widget.onDelete,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Colors.red.shade400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedPrice(dynamic locale, ColorScheme color) {
    final price = _currentPrice;

    if (price == null) {
      return Text(
        locale.select_vendor_to_show_price,
        style: getRegularStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size11,
          color: color.onSurfaceVariant,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _priceAnimationController,
      builder: (context, child) {
        return SlideTransition(
          position: _priceSlideAnimation,
          child: FadeTransition(
            opacity: _priceFadeAnimation,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_offer, size: 12, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  '${price.toStringAsFixed(0)} ${locale.currency}/${widget.item.unit}',
                  style: getBoldStyle(
                    color: AppColors.primary,
                    fontFamily: FontConstant.cairo,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1),
          color: AppColors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 18, color: AppColors.black),
      ),
    );
  }
}
