import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/brand/presentation/utils/brand_filter_label_localizer.dart';
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

    final color = context.colorScheme;
    final sortedUnits = List<String>.from(widget.units)..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localization.brand_filter_unit_title,
          style: AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.w600,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.md),
        FilterOptionGrid(
          options: sortedUnits
              .map((value) => localizeBrandFilterLabel(context, value))
              .toList(),
          selectedValue:
              localSelectedUnit == null ? null : localizeBrandFilterLabel(context, localSelectedUnit!),
          onOptionTap: (unit) {
            final rawUnit = sortedUnits.firstWhere(
              (value) => localizeBrandFilterLabel(context, value) == unit,
              orElse: () => unit,
            );
            final newSelection = localSelectedUnit == rawUnit ? null : rawUnit;
            setState(() => localSelectedUnit = newSelection);
            widget.onUnitChanged(newSelection);
          },
        ),
      ],
    );
  }
}
