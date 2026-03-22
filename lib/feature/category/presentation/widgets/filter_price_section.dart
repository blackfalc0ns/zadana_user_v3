import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';

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
          min: 0,
          max: 1000,
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
