import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_vertical_filter_chip.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filter_option_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filter_subcategory_entity.dart';

class SubcategoryFilterSection extends StatelessWidget {
  const SubcategoryFilterSection({
    super.key,
    required this.categories,
    required this.subcategories,
    required this.selectedCategory,
    required this.selectedSubcategory,
    required this.onSubcategoryChanged,
  });

  final List<BrandFilterOptionEntity> categories;
  final List<BrandFilterSubcategoryEntity> subcategories;
  final String? selectedCategory;
  final String? selectedSubcategory;
  final ValueChanged<String?> onSubcategoryChanged;

  @override
  Widget build(BuildContext context) {
    if (selectedCategory == null) {
      return const SizedBox.shrink();
    }

    final color = context.colorScheme;

    final selectedCategoryId = categories
        .firstWhere(
          (item) => item.name == selectedCategory,
          orElse: () => const BrandFilterOptionEntity(id: '', name: ''),
        )
        .id;

    final availableSubcategories = subcategories
        .where(
          (item) =>
              selectedCategoryId.isEmpty ||
              item.categoryId == selectedCategoryId,
        )
        .where((item) => item.name.trim().isNotEmpty)
        .toSet()
        .toList();

    if (availableSubcategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localization.brand_filter_type_title,
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
            childAspectRatio: 0.85,
            crossAxisSpacing: Spacing.sm,
            mainAxisSpacing: Spacing.sm,
          ),
          itemCount: availableSubcategories.length,
          itemBuilder: (context, index) {
            final subcategory = availableSubcategories[index];
            final isSelected = selectedSubcategory == subcategory.name;

            return CustomVerticalFilterChip(
              label: subcategory.name,
              imageUrl: subcategory.imageUrl,
              isSelected: isSelected,
              selectedColor: color.primary,
              onTap: () {
                final newSelection =
                    isSelected ? null : subcategory.name;
                onSubcategoryChanged(newSelection);
              },
            );
          },
        ),
      ],
    );
  }
}
