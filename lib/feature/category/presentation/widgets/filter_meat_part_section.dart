import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/category/data/fake/category_fake_data.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_option_grid.dart';
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
        !kProductParts[widget.selectedCategory]!.containsKey(
          widget.selectedProductType,
        )) {
      return const SizedBox.shrink();
    }

    final parts =
        kProductParts[widget.selectedCategory!]![widget.selectedProductType!] ??
        [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientSectionTitle(title: locale.filter_part),
        const SizedBox(height: Spacing.sm),
        FilterOptionGrid(
          options: parts,
          selectedValue: localSelectedPart,
          onOptionTap: (part) {
            final newSelection = localSelectedPart == part ? null : part;
            setState(() {
              localSelectedPart = newSelection;
            });
            widget.onPartSelected(newSelection);
          },
        ),
      ],
    );
  }
}
