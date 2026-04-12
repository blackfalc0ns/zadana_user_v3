import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/formatters/price_formatter.dart';

class PriceText extends StatelessWidget {
  const PriceText({
    super.key,
    required this.price,
    this.oldPrice,
    this.unit,
    this.style,
    this.compact = false,
    this.fontScale = 1,
  });

  final double price;
  final double? oldPrice;
  final String? unit;
  final TextStyle? style;
  final bool compact;
  final double fontScale;

  @override
  Widget build(BuildContext context) {
    final priceStyle =
        style ??
        getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: (compact ? FontSize.size12 : FontSize.size14) * fontScale,
          color: AppColors.primary,
        );
    final currencyStyle = getSemiBoldStyle(
      fontFamily: FontConstant.cairo,
      fontSize: (compact ? FontSize.size8 : FontSize.size9) * fontScale,
      color: AppColors.primary,
    );
    final oldPriceStyle = AppTextStyles.bodySmall.copyWith(
      decoration: TextDecoration.lineThrough,
      decorationThickness: 1.2,
      color: AppColors.textHint,
      fontSize: (compact ? 8 : 9.5) * fontScale,
      height: 0.95,
    );
    final currencyLabel = unit ?? 'ريال';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (oldPrice != null) ...[
                SizedBox(height: compact ? 0.5 : 1),
                Text(
                  '${PriceFormatter.formatPrice(oldPrice!)} $currencyLabel',
                  style: oldPriceStyle,
                ),
              ],
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(PriceFormatter.formatPrice(price), style: priceStyle),
                  SizedBox(width: compact ? 1 : 2),
                  Text(currencyLabel, style: currencyStyle),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
