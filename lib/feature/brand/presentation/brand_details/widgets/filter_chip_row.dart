import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_filter_chip.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filter_option_entity.dart';

class FilterChipRow extends StatelessWidget {
  const FilterChipRow({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.showAllChip = true,
  });

  final List<BrandFilterOptionEntity> categories;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;
  final bool showAllChip;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();
    final color = context.colorScheme;

    return Container(
      height: 50,
      color: color.surface,
      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + (showAllChip ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
        itemBuilder: (context, index) {
          if (showAllChip && index == 0) {
            final isSelected = selectedCategory == null;
            return CustomFilterChip(
              label: context.localization.all_categories,
              icon: '\u{1F4CB}',
              isSelected: isSelected,
              onTap: () => onCategorySelected(null),
            );
          }

          final category = categories[index - (showAllChip ? 1 : 0)];
          final isSelected = selectedCategory == category.name;

          return CustomFilterChip(
            label: category.name,
            imageUrl: category.imageUrl,
            isSelected: isSelected,
            onTap: () => onCategorySelected(category.name),
          );
        },
      ),
    );
  }
}
