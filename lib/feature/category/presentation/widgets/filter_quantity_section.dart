import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/feature/category/data/fake/category_fake_data.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/gradient_section_title.dart';

class FilterQuantitySection extends StatelessWidget {
  const FilterQuantitySection({
    super.key,
    required this.selectedCategory,
    required this.selectedQuantity,
    required this.onQuantitySelected,
  });

  final String? selectedCategory;
  final String? selectedQuantity;
  final Function(String?) onQuantitySelected;

  @override
  Widget build(BuildContext context) {
    if (selectedCategory == null || !kQuantityOptions.containsKey(selectedCategory)) {
      return const SizedBox.shrink();
    }

    final quantities = kQuantityOptions[selectedCategory!] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GradientSectionTitle(title: 'الكمية'),
        const SizedBox(height: Spacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: quantities.map((quantity) => _buildQuantityChip(quantity)).toList(),
        ),
      ],
    );
  }

  Widget _buildQuantityChip(String quantity) {
    final isSelected = selectedQuantity == quantity;
    return GestureDetector(
      onTap: () {
        onQuantitySelected(isSelected ? null : quantity);
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
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                )
              : LinearGradient(
                  colors: [
                    Colors.grey[100]!,
                    Colors.grey[50]!,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
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
          quantity,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}