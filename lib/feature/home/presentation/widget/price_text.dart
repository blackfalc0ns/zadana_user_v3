import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
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
    final locale = context.localization;
    final priceStyle =
        style ??
        getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: (compact ? FontSize.size14 : FontSize.size14) * fontScale,
          color: AppColors.primary,
        );
    final currencyStyle = getBoldStyle(
      fontFamily: FontConstant.cairo,
      fontSize: (compact ? FontSize.size10 : FontSize.size10) * fontScale,
      color: AppColors.primary,
    );
    final oldPriceStyle = AppTextStyles.bodyLarge.copyWith(
      decoration: TextDecoration.lineThrough,
      decorationThickness: 1.2,
      color: AppColors.textHint,
      fontSize: (compact ? 11 : 12) * fontScale,
      height: compact ? 0.92 : 1,
    );
    final currencyLabel = unit ?? locale.currency;

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
                SizedBox(height: compact ? 0 : 1),
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
