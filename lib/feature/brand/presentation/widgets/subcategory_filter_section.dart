import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_product_model.dart';

class SubcategoryFilterSection extends StatefulWidget {
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
  State<SubcategoryFilterSection> createState() => _SubcategoryFilterSectionState();
}

class _SubcategoryFilterSectionState extends State<SubcategoryFilterSection> {
  String? localSelectedSubcategory;

  @override
  void initState() {
    super.initState();
    localSelectedSubcategory = widget.selectedSubcategory;
  }

  @override
  void didUpdateWidget(SubcategoryFilterSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedSubcategory != oldWidget.selectedSubcategory) {
      localSelectedSubcategory = widget.selectedSubcategory;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedCategory == null) return const SizedBox.shrink();

    final availableSubcategories = widget.allProducts
        .where((p) => p.category == widget.selectedCategory)
        .map((p) => p.subcategory)
        .where((s) => s != null)
        .cast<String>()
        .toSet()
        .toList();

    if (availableSubcategories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'النوع',
          style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: Spacing.md),
        Wrap(
          spacing: Spacing.sm,
          runSpacing: Spacing.sm,
          children: availableSubcategories
              .map((subcategory) => _buildChip(context, subcategory))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildChip(BuildContext context, String subcategory) {
    final color = context.colorScheme;
    final isSelected = localSelectedSubcategory == subcategory;

    return GestureDetector(
      onTap: () {
        final newSelection = isSelected ? null : subcategory;
        setState(() => localSelectedSubcategory = newSelection);
        widget.onSubcategoryChanged(newSelection);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    color.secondary.withValues(alpha: 0.8),
                    color.secondary.withValues(alpha: 0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    color.surfaceContainerHighest,
                    color.surfaceContainerHigh,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? color.secondary
                : color.outline.withValues(alpha: 0.35),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.secondary.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          subcategory,
          style: getRegularStyle(
            fontSize: FontSize.size12,
            fontFamily: FontConstant.cairo,
            color: isSelected ? color.onSecondary : color.onSurface,
          ),
        ),
      ),
    );
  }
}
