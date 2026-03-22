import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

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

  String _getUnitIcon(String unit) {
    switch (unit.toLowerCase()) {
      case 'لتر':
      case 'ل':
        return '🥛';
      case 'مل':
      case 'ملليلتر':
        return '🧃';
      case 'كيلو':
      case 'كجم':
      case 'كيلوجرام':
        return '⚖️';
      case 'جرام':
      case 'جم':
        return '📏';
      case 'قطعة':
      case 'حبة':
        return '🔢';
      case 'علبة':
      case 'كرتونة':
        return '📦';
      case 'كيس':
        return '🛍️';
      default:
        return '📏';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.units.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الكمية',
          style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: Spacing.md),
        Wrap(
          spacing: Spacing.sm,
          runSpacing: Spacing.sm,
          children: widget.units.map((unit) => _buildChip(context, unit)).toList(),
        ),
      ],
    );
  }

  Widget _buildChip(BuildContext context, String unit) {
    final color = context.colorScheme;
    final isSelected = localSelectedUnit == unit;

    return GestureDetector(
      onTap: () {
        final newSelection = isSelected ? null : unit;
        setState(() => localSelectedUnit = newSelection);
        widget.onUnitChanged(newSelection);
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
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.secondary.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              unit,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size12,
                color: isSelected ? color.onSecondary : color.onSurface,
              ).copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
