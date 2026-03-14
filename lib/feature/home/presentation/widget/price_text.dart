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
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _formatPrice(price),
          style: style ??
              AppTextStyles.labelLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(width: 2),
        Text(
          'ريال',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.primary,
            fontSize: 10,
          ),
        ),
        if (oldPrice != null) ...[
          const SizedBox(width: 4),
          Text(
            _formatPrice(oldPrice!),
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

  String _formatPrice(double price) {
    // إزالة الأصفار الزائدة من نهاية السعر
    if (price == price.toInt()) {
      // لو السعر رقم صحيح، اعرضه بدون كسور
      return price.toInt().toString();
    } else {
      // لو السعر فيه كسور، اعرضه مع إزالة الأصفار الزائدة
      return price.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');
    }
  }
}
