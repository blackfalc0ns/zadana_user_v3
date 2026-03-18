import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/widgets/custom_filter_chip.dart';

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

  String _getUnitIcon(String unit) {
    switch (unit.toLowerCase()) {
      case 'لتر':
      case 'ل': return '🥛';
      case 'مل':
      case 'ملليلتر': return '🧃';
      case 'كيلو':
      case 'كجم':
      case 'كيلوجرام': return '⚖️';
      case 'جرام':
      case 'جم': return '📏';
      case 'قطعة':
      case 'حبة': return '🔢';
      case 'علبة':
      case 'كرتونة': return '📦';
      case 'كيس': return '🛍️';
      default: return '📏';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (units.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('الحجم/الوحدة', style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: Spacing.md),
        Wrap(
          spacing: Spacing.sm,
          runSpacing: Spacing.sm,
          children: [
            CustomFilterChip(
              label: 'الكل',
              icon: '📏',
              isSelected: selectedUnit == null,
              onTap: () => onUnitChanged(null),
            ),
            ...units.map((unit) => CustomFilterChip(
              label: unit,
              icon: _getUnitIcon(unit),
              isSelected: selectedUnit == unit,
              onTap: () => onUnitChanged(unit),
            )),
          ],
        ),
      ],
    );
  }
}