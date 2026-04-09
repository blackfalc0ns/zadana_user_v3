import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_option_grid.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/gradient_section_title.dart';

class FilterQuantitySection extends StatefulWidget {
  const FilterQuantitySection({
    super.key,
    required this.quantities,
    required this.selectedQuantity,
    required this.onQuantitySelected,
  });

  final List<String> quantities;
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
    final quantities = widget.quantities;
    if (quantities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientSectionTitle(title: locale.quantity),
        const SizedBox(height: Spacing.sm),
        FilterOptionGrid(
          options: quantities,
          selectedValue: localSelectedQuantity,
          onOptionTap: (quantity) {
            final newSelection =
                localSelectedQuantity == quantity ? null : quantity;
            setState(() {
              localSelectedQuantity = newSelection;
            });
            widget.onQuantitySelected(newSelection);
          },
        ),
      ],
    );
  }
}
