import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/widgets/custom_filter_chip.dart';

class PriceRangeSection extends StatelessWidget {
  const PriceRangeSection({
    super.key,
    required this.priceRange,
    required this.onChanged,
  });

  final RangeValues priceRange;
  final ValueChanged<RangeValues> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('نطاق السعر', style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: Spacing.md),
        RangeSlider(
          values: priceRange,
          min: 0,
          max: 500,
          divisions: 50,
          labels: RangeLabels('${priceRange.start.round()} ج.م', '${priceRange.end.round()} ج.م'),
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${priceRange.start.round()} ج.م', style: AppTextStyles.bodySmall),
            Text('${priceRange.end.round()} ج.م', style: AppTextStyles.bodySmall),
          ],
        ),
      ],
    );
  }
}

class CategoryFilterSection extends StatelessWidget {
  const CategoryFilterSection({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;

  String _getCategoryIcon(String category) {
    switch (category) {
      case 'الألبان': return '🥛';
      case 'الزبادي': return '🥛';
      case 'العصائر': return '🧃';
      case 'الأجبان': return '🧀';
      case 'الزبدة والقشطة': return '🧈';
      default: return '📦';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('الفئة', style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: Spacing.md),
        Wrap(
          spacing: Spacing.sm,
          runSpacing: Spacing.sm,
          children: [
            CustomFilterChip(
              label: 'الكل',
              icon: '📋',
              isSelected: selectedCategory == null,
              onTap: () => onCategoryChanged(null),
            ),
            ...categories.map((category) => CustomFilterChip(
              label: category,
              icon: _getCategoryIcon(category),
              isSelected: selectedCategory == category,
              onTap: () => onCategoryChanged(category),
            )),
          ],
        ),
      ],
    );
  }
}