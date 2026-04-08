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
          fontSize: (compact ? FontSize.size13 : FontSize.size15) * fontScale,
          color: AppColors.primary,
        );
    final currencyStyle = getSemiBoldStyle(
      fontFamily: FontConstant.cairo,
      fontSize: (compact ? FontSize.size9 : FontSize.size10) * fontScale,
      color: AppColors.primary,
    );
    final oldPriceStyle = AppTextStyles.bodySmall.copyWith(
      decoration: TextDecoration.lineThrough,
      decorationThickness: 1.2,
      color: AppColors.textHint,
      fontSize: (compact ? 9.5 : 11) * fontScale,
    );
    final unitStyle = AppTextStyles.bodySmall.copyWith(
      color: AppColors.textHint,
      fontSize: (compact ? 9 : 10) * fontScale,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(PriceFormatter.formatPrice(price), style: priceStyle),
              SizedBox(width: compact ? 1 : 2),
              Text('ريال', style: currencyStyle),
              if (oldPrice != null) ...[
                SizedBox(width: compact ? 2 : 4),
                Text(
                  PriceFormatter.formatPrice(oldPrice!),
                  style: oldPriceStyle,
                ),
              ],
            ],
          ),
        ),
        if (unit != null && unit!.isNotEmpty) ...[
          SizedBox(height: compact ? 1 : 2),
          Text(
            unit!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: unitStyle,
          ),
        ],
      ],
    );
  }
}
