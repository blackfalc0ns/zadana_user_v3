import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/widgets/discount_badge.dart';
import 'package:zadana_user_v3/core/widgets/product_image.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final String? selectedVendorId;
  final String? loadedVendorId;
  final bool isLoadingSelectedVendorPrices;
  final int priceAnimationVersion;
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
    this.loadedVendorId,
    this.isLoadingSelectedVendorPrices = false,
    this.priceAnimationVersion = 0,
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
      final vendorPrice = item.getPriceForVendor(
        selectedVendorId!,
        loadedVendorId: loadedVendorId,
      );
      if (vendorPrice != null &&
          vendorPrice.isDiscounted &&
          vendorPrice.oldPrice != null &&
          vendorPrice.oldPrice! > vendorPrice.price) {
        final discountPercent =
            ((vendorPrice.oldPrice! - vendorPrice.price) /
                    vendorPrice.oldPrice! *
                    100)
                .round();
        discountText = '$discountPercent%';
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Ink(
              decoration: BoxDecoration(
                border: Border.all(
                  color: color.outline.withValues(alpha: 0.12),
                ),
                color: color.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: color.shadow.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  ProductImage(
                    emoji: '',
                    url: item.imageUrl,
                    width: 68,
                    height: 68,
                    borderRadius: Spacing.cardRadius,
                    heroTag: productHeroTag(
                      item.productId,
                      source: 'cart-item',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size13,
                            color: color.onSurface,
                          ),
                        ),
                        const SizedBox(height: 3),
                        _buildPrice(locale, color),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _buildButton(Icons.remove, onDecrement),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: color.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${item.quantity}',
                                style: getBoldStyle(
                                  fontFamily: FontConstant.cairo,
                                  fontSize: FontSize.size13,
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
                  const SizedBox(width: 6),
                  _buildDeleteButton(),
                ],
              ),
            ),
            if (discountText != null)
              Positioned(
                left: 0,
                child: DiscountBadge(
                  discountText: discountText,
                  shadowColor: color.shadow,
                  trianglesize: 38,
                  fontSize: 11,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onDelete,
        borderRadius: BorderRadius.circular(6),
        child: Ink(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(Iconsax.trash, size: 18, color: Colors.red.shade400),
        ),
      ),
    );
  }

  Widget _buildPrice(dynamic locale, ColorScheme color) {
    if (selectedVendorId == null) {
      return _wrapPriceChangeAnimation(
        child: Text(
          locale.select_vendor_to_show_price,
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size10,
            color: color.onSurfaceVariant,
          ),
        ),
        priceKey: 'prompt',
      );
    }

    if (isLoadingSelectedVendorPrices) {
      return _wrapPriceChangeAnimation(
        child: _buildLoadingPrice(color),
        priceKey: 'loading-$selectedVendorId',
      );
    }

    final isAvailable = item.isAvailableAt(
      selectedVendorId!,
      loadedVendorId: loadedVendorId,
    );
    if (!isAvailable) {
      return _wrapPriceChangeAnimation(
        child: _buildUnavailableBadge(color),
        priceKey: 'unavailable',
      );
    }

    final vendorPrice = item.getPriceForVendor(
      selectedVendorId!,
      loadedVendorId: loadedVendorId,
    );
    final price = vendorPrice?.price;
    final oldPrice = vendorPrice?.oldPrice;
    final isDiscounted = vendorPrice?.isDiscounted ?? false;

    if (price == null) {
      return _wrapPriceChangeAnimation(
        child: Text(
          locale.select_vendor_to_show_price,
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size10,
            color: color.onSurfaceVariant,
          ),
        ),
        priceKey: 'missing-price',
      );
    }

    final hasDiscount = isDiscounted && oldPrice != null && oldPrice > price;
    final priceWidget = animatePrice
        ? _buildAnimatedPrice(locale, color, oldPrice, price, hasDiscount)
        : hasDiscount
        ? _buildDiscountedPrice(locale, color, oldPrice, price)
        : _buildRegularPrice(locale, price);

    return _wrapPriceChangeAnimation(
      child: priceWidget,
      priceKey:
          '$selectedVendorId-$loadedVendorId-$priceAnimationVersion-$price-$oldPrice-$isDiscounted',
    );
  }

  Widget _wrapPriceChangeAnimation({
    required Widget child,
    required String priceKey,
  }) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.18, 0),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: KeyedSubtree(key: ValueKey(priceKey), child: child),
    );
  }

  Widget _buildUnavailableBadge(ColorScheme color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, size: 12, color: AppColors.error),
          const SizedBox(width: 4),
          Text(
            'غير متوفر',
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size11,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingPrice(ColorScheme color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 1.6,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          'جاري تحديث السعر',
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size11,
            color: color.onSurfaceVariant,
          ),
        ),
      ],
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
          : _buildRegularPrice(locale, newPrice),
    );
  }

  Widget _buildDiscountedPrice(
    dynamic locale,
    ColorScheme color,
    double oldPrice,
    double newPrice,
  ) {
    return Row(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${newPrice.toStringAsFixed(0)} ${locale.currency}/${item.unit}',
          style: getBoldStyle(
            color: AppColors.primary,
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size13,
          ),
        ),
        Text(
          oldPrice.toStringAsFixed(0),
          style:
              getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size12,
                color: color.onSurfaceVariant,
              ).copyWith(
                decoration: TextDecoration.lineThrough,
                decorationColor: color.onSurfaceVariant.withValues(alpha: 0.6),
                decorationThickness: 1.2,
              ),
        ),
      ],
    );
  }

  Widget _buildRegularPrice(dynamic locale, double price) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.local_offer, size: 11, color: AppColors.primary),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            '${price.toStringAsFixed(0)} ${locale.currency}/${item.unit}',
            overflow: TextOverflow.ellipsis,
            style: getBoldStyle(
              color: AppColors.primary,
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Ink(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1),
            color: AppColors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 15, color: AppColors.black),
        ),
      ),
    );
  }
}

