import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/category/data/fake/category_fake_data.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/gradient_section_title.dart';

class FilterMeatPartSection extends StatefulWidget {
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
  State<FilterMeatPartSection> createState() => _FilterMeatPartSectionState();
}

class _FilterMeatPartSectionState extends State<FilterMeatPartSection> {
  String? localSelectedPart;

  @override
  void initState() {
    super.initState();
    localSelectedPart = widget.selectedPart;
  }

  @override
  void didUpdateWidget(FilterMeatPartSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedPart != oldWidget.selectedPart) {
      localSelectedPart = widget.selectedPart;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    if (widget.selectedCategory == null || 
        widget.selectedProductType == null || 
        !kProductParts.containsKey(widget.selectedCategory) ||
        !kProductParts[widget.selectedCategory]!.containsKey(widget.selectedProductType)) {
      return const SizedBox.shrink();
    }

    final parts = kProductParts[widget.selectedCategory!]![widget.selectedProductType!] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientSectionTitle(title: locale.filter_part),
        const SizedBox(height: Spacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: parts.map((part) => _buildPartChip(context, part)).toList(),
        ),
      ],
    );
  }

  Widget _buildPartChip(BuildContext context, String part) {
    final color = context.colorScheme;
    final isSelected = localSelectedPart == part;

    return GestureDetector(
      onTap: () {
        final newSelection = isSelected ? null : part;
        setState(() {
          localSelectedPart = newSelection;
        });
        widget.onPartSelected(newSelection);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected 
              ? LinearGradient(
                  colors: [
                    color.secondary.withValues(alpha: 0.9),
                    color.secondary.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : LinearGradient(
                  colors: [
                    color.surfaceContainerHighest,
                    color.surfaceContainerHigh,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? color.secondary
                : color.outline.withValues(alpha: 0.35),
            width: 1.2,
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
          part,
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
