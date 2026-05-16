import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class ProductHeaderSection extends StatelessWidget {
  const ProductHeaderSection({
    super.key,
    required this.productName,
    this.unit,
    this.displaySize,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  final String productName;
  final String? unit;
  final String? displaySize;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final quantityBackground = Color.alphaBlend(
      color.surfaceTint.withValues(alpha: 0.03),
      color.surface,
    );

    return Container(
      
      color: color.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: AppTextStyles.h3.copyWith(color: color.onSurface),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.sm),
          _QuantitySelector(
            quantity: quantity,
            onIncrease: onIncrease,
            onDecrease: onDecrease,
            quantityBackground: quantityBackground,
            quantityBorderColor: color.outlineVariant,
            quantityTextColor: color.onSurface,
            disabledButtonColor: color.surfaceContainerHighest,
            disabledIconColor: color.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    required this.quantityBackground,
    required this.quantityBorderColor,
    required this.quantityTextColor,
    required this.disabledButtonColor,
    required this.disabledIconColor,
  });

  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final Color quantityBackground;
  final Color quantityBorderColor;
  final Color quantityTextColor;
  final Color disabledButtonColor;
  final Color disabledIconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _QuantityButton(
          icon: Icons.remove,
          onTap: quantity > 1 ? onDecrease : null,
          disabledButtonColor: disabledButtonColor,
          disabledIconColor: disabledIconColor,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: quantityBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: quantityBorderColor),
          ),
          child: Text(
            quantity.toString(),
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: quantityTextColor,
              fontSize: 16,
            ),
          ),
        ),
        _QuantityButton(
          icon: Icons.add,
          onTap: onIncrease,
          disabledButtonColor: disabledButtonColor,
          disabledIconColor: disabledIconColor,
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.onTap,
    required this.disabledButtonColor,
    required this.disabledIconColor,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color disabledButtonColor;
  final Color disabledIconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: onTap != null ? AppColors.primary : disabledButtonColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap != null ? AppColors.white : disabledIconColor,
        ),
      ),
    );
  }
}
