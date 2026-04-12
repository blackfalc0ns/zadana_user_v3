import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_option_grid.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/gradient_section_title.dart';

class FilterOptionSection extends StatefulWidget {
  const FilterOptionSection({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onOptionSelected,
  });

  final String title;
  final List<String> options;
  final String? selectedValue;
  final Function(String?) onOptionSelected;

  @override
  State<FilterOptionSection> createState() => _FilterOptionSectionState();
}

class _FilterOptionSectionState extends State<FilterOptionSection> {
  String? localSelectedValue;

  @override
  void initState() {
    super.initState();
    localSelectedValue = widget.selectedValue;
  }

  @override
  void didUpdateWidget(FilterOptionSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue ||
        widget.options != oldWidget.options) {
      localSelectedValue = widget.selectedValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.options.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientSectionTitle(title: widget.title),
        const SizedBox(height: Spacing.sm),
        FilterOptionGrid(
          options: widget.options,
          selectedValue: localSelectedValue,
          onOptionTap: (value) {
            final newSelection = localSelectedValue == value ? null : value;
            setState(() => localSelectedValue = newSelection);
            widget.onOptionSelected(newSelection);
          },
        ),
      ],
    );
  }
}
