import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/widgets/custom_filter_chip.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_product_model.dart';

class SubcategoryFilterSection extends StatelessWidget {
  const SubcategoryFilterSection({
    super.key,
    required this.allProducts,
    required this.selectedCategory,
    required this.selectedSubcategory,
    required this.onSubcategoryChanged,
  });

  final List<BrandProductModel> allProducts;
  final String? selectedCategory;
  final String? selectedSubcategory;
  final ValueChanged<String?> onSubcategoryChanged;

  @override
  Widget build(BuildContext context) {
    if (selectedCategory == null) return const SizedBox.shrink();

    final availableSubcategories = allProducts
        .where((p) => p.category == selectedCategory)
        .map((p) => p.subcategory)
        .where((s) => s != null)
        .cast<String>()
        .toSet()
        .toList();

    if (availableSubcategories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('النوع الفرعي', style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: Spacing.md),
        Wrap(
          spacing: Spacing.sm,
          runSpacing: Spacing.sm,
          children: [
            CustomFilterChip(
              label: 'الكل',
              icon: '•',
              isSelected: selectedSubcategory == null,
              onTap: () => onSubcategoryChanged(null),
            ),
            ...availableSubcategories.map((subcategory) => CustomFilterChip(
              label: subcategory,
              icon: '•',
              isSelected: selectedSubcategory == subcategory,
              onTap: () => onSubcategoryChanged(subcategory),
            )),
          ],
        ),
      ],
    );
  }
}