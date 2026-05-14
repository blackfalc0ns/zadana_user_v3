import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class FilterPriceSection extends StatelessWidget {
  const FilterPriceSection({
    super.key,
    required this.priceRange,
    required this.priceBounds,
    required this.onPriceRangeChanged,
  });

  final RangeValues priceRange;
  final RangeValues priceBounds;
  final Function(RangeValues) onPriceRangeChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final sliderMin = priceBounds.start;
    final sliderMax = priceBounds.end <= priceBounds.start
        ? priceBounds.start + 1
        : priceBounds.end;
    final clampedRange = RangeValues(
      priceRange.start.clamp(sliderMin, sliderMax),
      priceRange.end.clamp(sliderMin, sliderMax),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.price_range,
          style: AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.w600,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.md),
        RangeSlider(
          values: clampedRange,
          min: sliderMin,
          max: sliderMax,
          divisions: 20,
          labels: RangeLabels(
            '${clampedRange.start.round()} ${locale.currency}',
            '${clampedRange.end.round()} ${locale.currency}',
          ),
          onChanged: onPriceRangeChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${clampedRange.start.round()} ${locale.currency}',
              style: AppTextStyles.bodySmall.copyWith(
                color: color.onSurfaceVariant,
              ),
            ),
            Text(
              '${clampedRange.end.round()} ${locale.currency}',
              style: AppTextStyles.bodySmall.copyWith(
                color: color.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
