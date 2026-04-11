import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/animated_price_display.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_animations.dart';

class VendorInfoRow extends StatelessWidget {
  final String selectedVendorId;
  final String selectedVendorName;
  final int itemsCount;
  final double totalPrice;
  final CartAnimations animations;

  const VendorInfoRow({
    super.key,
    required this.selectedVendorId,
    required this.selectedVendorName,
    required this.itemsCount,
    required this.totalPrice,
    required this.animations,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Row(
      children: [
        _buildVendorInfo(context, locale),
        const Spacer(),
        AnimatedPriceDisplay(totalPrice: totalPrice, animations: animations),
      ],
    );
  }

  Widget _buildVendorInfo(BuildContext context, locale) {
    return Row(
      children: [
        _buildVendorEmoji(context),
        const SizedBox(width: 10),
        _buildVendorDetails(context, locale),
      ],
    );
  }

  Widget _buildVendorEmoji(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.storefront_rounded, color: color.primary, size: 24),
    );
  }

  Widget _buildVendorDetails(BuildContext context, locale) {
    final color = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          selectedVendorName,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size16,
            color: color.onSurface,
          ),
        ),
        Text(
          '$itemsCount ${locale.product}',
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: color.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
