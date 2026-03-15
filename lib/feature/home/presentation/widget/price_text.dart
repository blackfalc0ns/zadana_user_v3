import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/formatters/price_formatter.dart';

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
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          PriceFormatter.formatPrice(price),
          style:
              style ??
              AppTextStyles.labelLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(width: 2),
        Text(
          'ريال',
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size10,
            color: AppColors.primary,
          ),
        ),
        if (oldPrice != null) ...[
          const SizedBox(width: 4),
          Text(
            PriceFormatter.formatPrice(oldPrice!),
            style: AppTextStyles.bodySmall.copyWith(
              decoration: TextDecoration.lineThrough,
              color: AppColors.textHint,
              fontSize: 11,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            'ريال',
            style: AppTextStyles.bodySmall.copyWith(
              decoration: TextDecoration.lineThrough,
              color: AppColors.textHint,
              fontSize: 9,
            ),
          ),
        ],
      ],
    );
  }
}
