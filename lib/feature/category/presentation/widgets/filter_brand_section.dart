import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/category/data/fake/category_fake_data.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/gradient_section_title.dart';

class FilterBrandSection extends StatefulWidget {
  const FilterBrandSection({
    super.key,
    required this.selectedCategory,
    required this.selectedBrand,
    required this.onBrandSelected,
  });

  final String? selectedCategory;
  final String? selectedBrand;
  final Function(String?) onBrandSelected;

  @override
  State<FilterBrandSection> createState() => _FilterBrandSectionState();
}

class _FilterBrandSectionState extends State<FilterBrandSection> {
  String? localSelectedBrand;

  @override
  void initState() {
    super.initState();
    localSelectedBrand = widget.selectedBrand;
  }

  @override
  void didUpdateWidget(FilterBrandSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedBrand != oldWidget.selectedBrand ||
        widget.selectedCategory != oldWidget.selectedCategory) {
      localSelectedBrand = widget.selectedBrand;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    if (widget.selectedCategory == null) {
      return const SizedBox.shrink();
    }

    final brands = getBrandsForCategory(widget.selectedCategory!);
    if (brands.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientSectionTitle(title: locale.filter_brand),
        const SizedBox(height: Spacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: brands.map((brand) => _buildBrandChip(context, brand)).toList(),
        ),
      ],
    );
  }

  Widget _buildBrandChip(BuildContext context, String brand) {
    final color = context.colorScheme;
    final isSelected = localSelectedBrand == brand;

    return GestureDetector(
      onTap: () {
        final newSelection = isSelected ? null : brand;
        setState(() {
          localSelectedBrand = newSelection;
        });
        widget.onBrandSelected(newSelection);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    color.secondary.withValues(alpha: 0.85),
                    color.secondary.withValues(alpha: 0.65),
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
          brand,
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
