import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filter_option_entity.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_option_grid.dart';

class MeasurementUnitFilterSection extends StatelessWidget {
  const MeasurementUnitFilterSection({
    super.key,
    required this.measurementUnits,
    required this.selectedMeasurementUnitId,
    required this.onMeasurementUnitChanged,
  });

  final List<BrandFilterOptionEntity> measurementUnits;
  final String? selectedMeasurementUnitId;
  final ValueChanged<String?> onMeasurementUnitChanged;

  @override
  Widget build(BuildContext context) {
    if (measurementUnits.isEmpty) {
      return const SizedBox.shrink();
    }

    final color = context.colorScheme;
    final names = measurementUnits
        .map((item) => item.name.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);

    final selectedName = _nameFromId(selectedMeasurementUnitId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localization.brand_filter_measurement_unit_title,
          style: AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.w600,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.md),
        FilterOptionGrid(
          options: names,
          selectedValue: selectedName,
          onOptionTap: (name) {
            if (selectedName == name) {
              onMeasurementUnitChanged(null);
            } else {
              onMeasurementUnitChanged(_idFromName(name));
            }
          },
        ),
      ],
    );
  }

  String? _nameFromId(String? id) {
    if (id == null || id.isEmpty) return null;
    for (final item in measurementUnits) {
      if (item.id == id) return item.name.trim();
    }
    return null;
  }

  String? _idFromName(String? name) {
    if (name == null || name.isEmpty) return null;
    for (final item in measurementUnits) {
      if (item.name.trim() == name) return item.id;
    }
    return null;
  }
}
