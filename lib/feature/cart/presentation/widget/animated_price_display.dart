import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/formatters/price_formatter.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_animations.dart';

class AnimatedPriceDisplay extends StatelessWidget {
  final double totalPrice;
  final CartAnimations animations;

  const AnimatedPriceDisplay({
    super.key,
    required this.totalPrice,
    required this.animations,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animations.priceSlideAnimation,
      builder: (context, child) {
        return SlideTransition(
          position: animations.priceSlideAnimation,
          child: FadeTransition(
            opacity: animations.priceFadeAnimation,
            child: _buildPriceContainer(),
          ),
        );
      },
    );
  }

  Widget _buildPriceContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt, color: AppColors.primary, size: 14),
          const SizedBox(width: 4),
          Text(
            " ${PriceFormatter.formatPrice(totalPrice)} ريال",
            // '${totalPrice.toStringAsFixed(2)} ريال',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              color: AppColors.primary,
              fontSize: FontSize.size13,
            ),
          ),
        ],
      ),
    );
  }
}
