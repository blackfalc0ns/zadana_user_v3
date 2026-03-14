import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/feature/category/data/fake/category_fake_data.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/gradient_section_title.dart';

class FilterAnimalTypeSection extends StatelessWidget {
  const FilterAnimalTypeSection({
    super.key,
    required this.selectedCategory,
    required this.selectedProductType,
    required this.onProductTypeSelected,
  });

  final String? selectedCategory;
  final String? selectedProductType;
  final Function(String?) onProductTypeSelected;

  @override
  Widget build(BuildContext context) {
    if (selectedCategory == null || !kProductTypes.containsKey(selectedCategory)) {
      return const SizedBox.shrink();
    }

    final productTypes = kProductTypes[selectedCategory!] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GradientSectionTitle(title: 'النوع'),
        const SizedBox(height: Spacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: productTypes.map((type) => _buildTypeChip(type)).toList(),
        ),
      ],
    );
  }

  Widget _buildTypeChip(String type) {
    final isSelected = selectedProductType == type;
    return GestureDetector(
      onTap: () {
        onProductTypeSelected(isSelected ? null : type);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected 
              ? LinearGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.8),
                    AppColors.secondary.withValues(alpha: 0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    Colors.grey[100]!,
                    Colors.grey[50]!,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.secondary : Colors.transparent,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Text(
          type,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}