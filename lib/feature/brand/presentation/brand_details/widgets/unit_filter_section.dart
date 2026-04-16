import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_option_grid.dart';

class UnitFilterSection extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (units.isEmpty) {
      return const SizedBox.shrink();
    }

    final color = context.colorScheme;
    final sortedUnits = List<String>.from(units)..sort();

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
          options: sortedUnits,
          selectedValue: selectedUnit,
          onOptionTap: (unit) {
            final newSelection = selectedUnit == unit ? null : unit;
            onUnitChanged(newSelection);
          },
        ),
      ],
    );
  }
}
