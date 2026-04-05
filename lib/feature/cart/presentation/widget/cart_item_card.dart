import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/widgets/discount_badge.dart';
import 'package:zadana_user_v3/core/widgets/product_image.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final String? selectedVendorId;
  final VoidCallback onTap;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;
  final bool enableHeroAnimation;
  final bool animatePrice;

  const CartItemCard({
    super.key,
    required this.item,
    required this.selectedVendorId,
    required this.onTap,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
    this.enableHeroAnimation = false,
    this.animatePrice = false,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    // Calculate discount based on selected vendor
    String? discountText;
    if (selectedVendorId != null) {
      final vendorPrice = item.getPriceForVendor(selectedVendorId!);
      if (vendorPrice != null && vendorPrice.isDiscounted && vendorPrice.oldPrice != null && vendorPrice.oldPrice! > vendorPrice.price) {
        final discountPercent = ((vendorPrice.oldPrice! - vendorPrice.price) / vendorPrice.oldPrice! * 100).round();
        discountText = '$discountPercent%';
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
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
                  emoji: item.imageUrl,
                  url: '',
                  width: 80,
                  height: 80,
                  borderRadius: Spacing.cardRadius,
                  heroTag: productHeroTag(item.id),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size14,
                          color: color.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _buildPrice(locale, color),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildButton(Icons.remove, onDecrement),
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
                              '${item.quantity}',
                              style: getBoldStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size14,
                                color: color.onSurface,
                              ),
                            ),
                          ),
                          _buildButton(Icons.add, onIncrement),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onDelete,
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
          if (discountText != null)
            Positioned(
              left: 0,
              child: DiscountBadge(
                discountText: discountText,
                shadowColor: color.shadow,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPrice(dynamic locale, ColorScheme color) {
    // Check if vendor is selected
    if (selectedVendorId == null) {
      return Text(
        locale.select_vendor_to_show_price,
        style: getRegularStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size11,
          color: color.onSurfaceVariant,
        ),
      );
    }

    // Check if item is available at selected vendor
    final isAvailable = item.isAvailableAt(selectedVendorId!);
    
    if (!isAvailable) {
      return _buildUnavailableBadge(locale, color);
    }

    final vendorPrice = item.getPriceForVendor(selectedVendorId!);
    final price = vendorPrice?.price;
    final oldPrice = vendorPrice?.oldPrice;
    final isDiscounted = vendorPrice?.isDiscounted ?? false;
    final hasDiscount = isDiscounted && oldPrice != null && oldPrice > price!;

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

    if (animatePrice) {
      return _buildAnimatedPrice(locale, color, oldPrice, price, hasDiscount);
    }

    return hasDiscount
        ? _buildDiscountedPrice(locale, color, oldPrice!, price)
        : _buildRegularPrice(locale, color, price);
  }

  /// Widget for displaying unavailable item badge
  Widget _buildUnavailableBadge(dynamic locale, ColorScheme color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline,
            size: 14,
            color: AppColors.error,
          ),
          const SizedBox(width: 6),
          Text(
            'غير متوفر',
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size12,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedPrice(
    dynamic locale,
    ColorScheme color,
    double? oldPrice,
    double newPrice,
    bool hasDiscount,
  ) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset((1.0 - value) * 20, 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: hasDiscount && oldPrice != null
          ? _buildDiscountedPrice(locale, color, oldPrice, newPrice)
          : _buildRegularPrice(locale, color, newPrice),
    );
  }

  Widget _buildDiscountedPrice(
    dynamic locale,
    ColorScheme color,
    double oldPrice,
    double newPrice,
  ) {
    return Row(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          oldPrice.toStringAsFixed(0),
          style:
              getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size13,
                color: color.onSurfaceVariant,
              ).copyWith(
                decoration: TextDecoration.lineThrough,
                decorationColor: color.onSurfaceVariant.withValues(alpha: 0.6),
                decorationThickness: 1.5,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          '${newPrice.toStringAsFixed(0)} ${locale.currency}/${item.unit}',
          style: getBoldStyle(
            color: AppColors.primary,
            fontFamily: FontConstant.cairo,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildRegularPrice(dynamic locale, ColorScheme color, double price) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.local_offer, size: 12, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(
          '${price.toStringAsFixed(0)} ${locale.currency}/${item.unit}',
          style: getBoldStyle(
            color: AppColors.primary,
            fontFamily: FontConstant.cairo,
            fontSize: 13,
          ),
        ),
      ],
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
