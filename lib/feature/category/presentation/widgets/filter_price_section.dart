import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';

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
    final sliderMax = priceBounds.end <= priceBounds.start
        ? priceBounds.start + 1
        : priceBounds.end;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نطاق السعر',
          style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: Spacing.md),
        RangeSlider(
          values: priceRange,
          min: priceBounds.start,
          max: sliderMax,
          divisions: 20,
          labels: RangeLabels(
            '${priceRange.start.round()} ج.م',
            '${priceRange.end.round()} ج.م',
          ),
          onChanged: onPriceRangeChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${priceRange.start.round()} ج.م',
              style: AppTextStyles.bodySmall,
            ),
            Text(
              '${priceRange.end.round()} ج.م',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}
