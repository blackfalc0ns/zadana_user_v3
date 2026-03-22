import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/category/data/fake/category_fake_data.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/gradient_section_title.dart';

class FilterQuantitySection extends StatefulWidget {
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
  State<FilterQuantitySection> createState() => _FilterQuantitySectionState();
}

class _FilterQuantitySectionState extends State<FilterQuantitySection> {
  String? localSelectedQuantity;

  @override
  void initState() {
    super.initState();
    localSelectedQuantity = widget.selectedQuantity;
  }

  @override
  void didUpdateWidget(FilterQuantitySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedQuantity != oldWidget.selectedQuantity) {
      localSelectedQuantity = widget.selectedQuantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    
    if (widget.selectedCategory == null || !kQuantityOptions.containsKey(widget.selectedCategory)) {
      return const SizedBox.shrink();
    }

    final quantities = kQuantityOptions[widget.selectedCategory!] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientSectionTitle(title: locale.quantity),
        const SizedBox(height: Spacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: quantities.map((quantity) => _buildQuantityChip(context, quantity)).toList(),
        ),
      ],
    );
  }

  Widget _buildQuantityChip(BuildContext context, String quantity) {
    final color = context.colorScheme;
    final isSelected = localSelectedQuantity == quantity;
    
    return GestureDetector(
      onTap: () {
        final newSelection = isSelected ? null : quantity;
        setState(() {
          localSelectedQuantity = newSelection;
        });
        widget.onQuantitySelected(newSelection);
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
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                )
              : LinearGradient(
                  colors: [
                    color.surfaceContainerHighest,
                    color.surfaceContainerHigh,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
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
          quantity,
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size12,
            color: isSelected ? color.onSecondary : color.onSurface,
          ).copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
