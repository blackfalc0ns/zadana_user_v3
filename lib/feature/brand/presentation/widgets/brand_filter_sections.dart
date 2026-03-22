import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/widgets/custom_vertical_filter_chip.dart';

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
        Text(
          'نطاق السعر',
          style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: Spacing.md),
        RangeSlider(
          values: priceRange,
          min: 0,
          max: 500,
          divisions: 50,
          labels: RangeLabels(
            '${priceRange.start.round()} ج.م',
            '${priceRange.end.round()} ج.م',
          ),
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

class CategoryFilterSection extends StatefulWidget {
  const CategoryFilterSection({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;

  @override
  State<CategoryFilterSection> createState() => _CategoryFilterSectionState();
}

class _CategoryFilterSectionState extends State<CategoryFilterSection> {
  bool showAllCategories = false;

  String _getCategoryIcon(String category) {
    switch (category) {
      case 'الألبان':
        return '🥛';
      case 'الزبادي':
        return '🥛';
      case 'العصائر':
        return '🧃';
      case 'الأجبان':
        return '🧀';
      case 'الزبدة والقشطة':
        return '🧈';
      default:
        return '📦';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) return const SizedBox.shrink();

    final color = Theme.of(context).colorScheme;
    final displayedCategories = showAllCategories
        ? widget.categories
        : widget.categories.take(8).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الفئة',
          style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: Spacing.md),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.9,
            crossAxisSpacing: Spacing.sm,
            mainAxisSpacing: Spacing.sm,
          ),
          itemCount: displayedCategories.length,
          itemBuilder: (context, index) {
            final category = displayedCategories[index];
            return CustomVerticalFilterChip(
              label: category,
              icon: _getCategoryIcon(category),
              isSelected: widget.selectedCategory == category,
              selectedColor: color.primary,
              onTap: () => widget.onCategoryChanged(
                widget.selectedCategory == category ? null : category,
              ),
            );
          },
        ),
        if (widget.categories.length > 8)
          Transform.translate(
            offset: const Offset(0, -12),
            child: Center(
              child: TextButton(
                onPressed: () => setState(() => showAllCategories = !showAllCategories),
                child: Text(showAllCategories ? 'عرض أقل' : 'عرض المزيد'),
              ),
            ),
          ),
      ],
    );
  }
}
