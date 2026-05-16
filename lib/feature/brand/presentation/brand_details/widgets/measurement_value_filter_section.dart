import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_option_grid.dart';

class MeasurementValueFilterSection extends StatelessWidget {
  const MeasurementValueFilterSection({
    super.key,
    required this.measurementValues,
    required this.selectedMeasurementValue,
    required this.onMeasurementValueChanged,
  });

  final List<double> measurementValues;
  final double? selectedMeasurementValue;
  final ValueChanged<double?> onMeasurementValueChanged;

  @override
  Widget build(BuildContext context) {
    if (measurementValues.isEmpty) {
      return const SizedBox.shrink();
    }

    final color = context.colorScheme;
    final sortedValues = List<double>.from(measurementValues)..sort();
    final labels = sortedValues.map(_formatValue).toList(growable: false);
    final selectedLabel = selectedMeasurementValue != null
        ? _formatValue(selectedMeasurementValue!)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localization.brand_filter_measurement_value_title,
          style: AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.w600,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.md),
        FilterOptionGrid(
          options: labels,
          selectedValue: selectedLabel,
          onOptionTap: (label) {
            if (selectedLabel == label) {
              onMeasurementValueChanged(null);
            } else {
              final index = labels.indexOf(label);
              if (index >= 0 && index < sortedValues.length) {
                onMeasurementValueChanged(sortedValues[index]);
              }
            }
          },
        ),
      ],
    );
  }

  String _formatValue(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }
}
