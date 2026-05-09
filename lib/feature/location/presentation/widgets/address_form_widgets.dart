import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class AddressFormWidgets {
  static Widget buildFieldLabel(BuildContext context, String label) {
    final color = context.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm),
      child: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(
          color: color.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static Widget buildLabelDropdown({
    required BuildContext context,
    required String? selectedLabel,
    required Map<String, String> labelOptions,
    required ValueChanged<String?> onChanged,
  }) {
    final color = context.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedLabel,
          hint: Builder(
            builder: (context) =>
                Text(context.localization.location_address_label_hint),
          ),
          isExpanded: true,
          items: labelOptions.keys.map((String label) {
            return DropdownMenuItem<String>(value: label, child: Text(label));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  static Widget buildLocationDisplay(BuildContext context, String addressLine) {
    final color = context.colorScheme;
    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: color.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: color.primary, size: 20),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(
              addressLine,
              style: AppTextStyles.bodySmall.copyWith(color: color.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildConfirmButton({
    required bool isLoading,
    required VoidCallback onPressed,
    required String text,
    required BuildContext context,
  }) {
    final color = context.colorScheme;
    return Container(
     padding: EdgeInsets.only(
       left: Spacing.screenH,
      right: Spacing.screenH,
      //   bottom: MediaQuery.of(context).padding.bottom + Spacing.base,
      //   top: Spacing.base,
    ),
      decoration: BoxDecoration(
        color: color.surface,
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.10),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: color.onPrimary,
                  ),
                )
              : Text(text),
        ),
      ),
    );
  }
}
