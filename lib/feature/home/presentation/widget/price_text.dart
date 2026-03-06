import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';

class PriceText extends StatelessWidget {
  const PriceText({
    super.key,
    required this.price,
    this.oldPrice,
    this.unit,
    this.style,
  });

  final double price;
  final double? oldPrice;
  final String? unit;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final priceStr =
        '\$${price.toStringAsFixed(2)}${unit != null ? '/$unit' : ''}';

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          priceStr,
          style: style ??
              AppTextStyles.labelLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
        ),
        if (oldPrice != null) ...[
          const SizedBox(width: 4),
          Text(
            '\$${oldPrice!.toStringAsFixed(2)}',
            style: AppTextStyles.bodySmall.copyWith(
              decoration: TextDecoration.lineThrough,
              color: AppColors.textHint,
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }
}
