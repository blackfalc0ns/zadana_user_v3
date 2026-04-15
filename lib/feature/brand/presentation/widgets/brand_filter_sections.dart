import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_vertical_filter_chip.dart';
import 'package:zadana_user_v3/feature/brand/presentation/utils/brand_filter_label_localizer.dart';

class PriceRangeSection extends StatelessWidget {
  const PriceRangeSection({
    super.key,
    required this.priceRange,
    required this.priceBounds,
    required this.onChanged,
  });

  final RangeValues priceRange;
  final RangeValues priceBounds;
  final ValueChanged<RangeValues> onChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final sliderMax = priceBounds.end <= priceBounds.start
        ? priceBounds.start + 1
        : priceBounds.end;

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
          values: priceRange,
          min: priceBounds.start,
          max: sliderMax,
          divisions: 50,
          labels: RangeLabels(
            '${priceRange.start.round()} ${locale.egp}',
            '${priceRange.end.round()} ${locale.egp}',
          ),
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${priceRange.start.round()} ${locale.currency}',
              style: AppTextStyles.bodySmall.copyWith(
                color: color.onSurfaceVariant,
              ),
            ),
            Text(
              '${priceRange.end.round()} ${locale.currency}',
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
    switch (category.trim().toLowerCase()) {
      case 'الألبان':
      case 'dairy':
        return '🥛';
      case 'الزبادي':
      case 'yogurt':
        return '🥣';
      case 'العصائر':
      case 'juices':
        return '🧃';
      case 'الأجبان':
      case 'cheese':
        return '🧀';
      case 'الزبدة والقشطة':
      case 'butter & cream':
        return '🧈';
      default:
        return '📦';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) return const SizedBox.shrink();

    final color = Theme.of(context).colorScheme;
    final locale = context.localization;
    final displayedCategories = showAllCategories
        ? widget.categories
        : widget.categories.take(8).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.brand_filter_category_title,
          style: AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.w600,
            color: color.onSurface,
          ),
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
              label: localizeBrandFilterLabel(context, category),
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
                onPressed: () =>
                    setState(() => showAllCategories = !showAllCategories),
                child: Text(
                  showAllCategories ? locale.show_less : locale.show_more,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
