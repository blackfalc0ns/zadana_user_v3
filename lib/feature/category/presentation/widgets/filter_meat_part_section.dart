import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/feature/category/data/fake/category_fake_data.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/gradient_section_title.dart';

class FilterMeatPartSection extends StatelessWidget {
  const FilterMeatPartSection({
    super.key,
    required this.selectedCategory,
    required this.selectedProductType,
    required this.selectedPart,
    required this.onPartSelected,
  });

  final String? selectedCategory;
  final String? selectedProductType;
  final String? selectedPart;
  final Function(String?) onPartSelected;

  @override
  Widget build(BuildContext context) {
    if (selectedCategory == null || 
        selectedProductType == null || 
        !kProductParts.containsKey(selectedCategory) ||
        !kProductParts[selectedCategory]!.containsKey(selectedProductType)) {
      return const SizedBox.shrink();
    }

    final parts = kProductParts[selectedCategory!]![selectedProductType!] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GradientSectionTitle(title: 'الصنف'),
        const SizedBox(height: Spacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: parts.map((part) => _buildPartChip(part)).toList(),
        ),
      ],
    );
  }

  Widget _buildPartChip(String part) {
    final isSelected = selectedPart == part;
    return GestureDetector(
      onTap: () {
        onPartSelected(isSelected ? null : part);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected 
              ? LinearGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.9),
                    AppColors.secondary.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : LinearGradient(
                  colors: [
                    Colors.grey[100]!,
                    Colors.grey[50]!,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
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
          part,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}