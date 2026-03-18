import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/gradient_section_title.dart';

class FilterPriceSection extends StatelessWidget {
  const FilterPriceSection({
    super.key,
    required this.priceRange,
    required this.onPriceRangeChanged,
  });

  final RangeValues priceRange;
  final Function(RangeValues) onPriceRangeChanged;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientSectionTitle(title: locale.price_range),
        const SizedBox(height: Spacing.sm),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${priceRange.start.round()} ${locale.currency}',
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size12,
                    color: color.primary,
                  ),
                ),
                Text(
                  locale.filter_part,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size12,
                    color: color.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${priceRange.end.round()} ${locale.currency}',
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size12,
                    color: color.secondary,
                  ),
                ),
              ],
            ),
            RangeSlider(
              values: priceRange,
              min: 0,
              max: 1000,
              divisions: 20,
              activeColor: color.primary,
              inactiveColor: color.surfaceContainerHighest,
              onChanged: onPriceRangeChanged,
            ),
          ],
        ),
      ],
    );
  }
}
