import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_option_grid.dart';

class UnitFilterSection extends StatefulWidget {
  const UnitFilterSection({
    super.key,
    required this.units,
    required this.selectedUnit,
    required this.onUnitChanged,
  });

  final List<String> units;
  final String? selectedUnit;
  final ValueChanged<String?> onUnitChanged;

  @override
  State<UnitFilterSection> createState() => _UnitFilterSectionState();
}

class _UnitFilterSectionState extends State<UnitFilterSection> {
  String? localSelectedUnit;

  @override
  void initState() {
    super.initState();
    localSelectedUnit = widget.selectedUnit;
  }

  @override
  void didUpdateWidget(UnitFilterSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedUnit != oldWidget.selectedUnit) {
      localSelectedUnit = widget.selectedUnit;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.units.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedUnits = List<String>.from(widget.units)..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الكمية',
          style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: Spacing.md),
        FilterOptionGrid(
          options: sortedUnits,
          selectedValue: localSelectedUnit,
          onOptionTap: (unit) {
            final newSelection = localSelectedUnit == unit ? null : unit;
            setState(() => localSelectedUnit = newSelection);
            widget.onUnitChanged(newSelection);
          },
        ),
      ],
    );
  }
}
