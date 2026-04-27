import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_vertical_filter_chip.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filter_option_entity.dart';

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

class CategoryFilterSection extends StatelessWidget {
  const CategoryFilterSection({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  final List<BrandFilterOptionEntity> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    final color = Theme.of(context).colorScheme;
    final locale = context.localization;

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
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CustomVerticalFilterChip(
              label: category.name,
              imageUrl: category.imageUrl,
              isSelected: selectedCategory == category.name,
              selectedColor: color.primary,
              onTap: () => onCategoryChanged(
                selectedCategory == category.name ? null : category.name,
              ),
            );
          },
        ),
      ],
    );
  }
}
