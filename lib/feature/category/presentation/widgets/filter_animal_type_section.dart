import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/category/data/fake/category_fake_data.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/gradient_section_title.dart';

class FilterAnimalTypeSection extends StatefulWidget {
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
  State<FilterAnimalTypeSection> createState() => _FilterAnimalTypeSectionState();
}

class _FilterAnimalTypeSectionState extends State<FilterAnimalTypeSection> {
  String? localSelectedProductType;

  @override
  void initState() {
    super.initState();
    localSelectedProductType = widget.selectedProductType;
  }

  @override
  void didUpdateWidget(FilterAnimalTypeSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedProductType != oldWidget.selectedProductType) {
      localSelectedProductType = widget.selectedProductType;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    if (widget.selectedCategory == null || !kProductTypes.containsKey(widget.selectedCategory)) {
      return const SizedBox.shrink();
    }

    final productTypes = kProductTypes[widget.selectedCategory!] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientSectionTitle(title: locale.filter_type),
        const SizedBox(height: Spacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: productTypes.map((type) => _buildTypeChip(context, type)).toList(),
        ),
      ],
    );
  }

  Widget _buildTypeChip(BuildContext context, String type) {
    final color = context.colorScheme;
    final isSelected = localSelectedProductType == type;

    return GestureDetector(
      onTap: () {
        final newSelection = isSelected ? null : type;
        setState(() {
          localSelectedProductType = newSelection;
        });
        widget.onProductTypeSelected(newSelection);
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
            color: isSelected ? color.secondary : Colors.transparent,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: color.secondary.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Text(
          type,
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