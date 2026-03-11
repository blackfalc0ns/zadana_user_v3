import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/widgets/app_text_field.dart';

class AddressFormWidgets {
  static Widget buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm),
      child: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static Widget buildLabelDropdown({
    required String? selectedLabel,
    required Map<String, String> labelOptions,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedLabel,
          hint: const Text('اختر تسمية العنوان'),
          isExpanded: true,
          items: labelOptions.keys.map((String label) {
            return DropdownMenuItem<String>(
              value: label,
              child: Text(label),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  static Widget buildLocationDisplay(String addressLine) {
    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(
              addressLine,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textPrimary,
              ),
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
    return Container(
      padding: EdgeInsets.only(
        left: Spacing.screenH,
        right: Spacing.screenH,
        bottom: MediaQuery.of(context).padding.bottom + Spacing.base,
        top: Spacing.base,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
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
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.textOnPrimary,
                  ),
                )
              : Text(text),
        ),
      ),
    );
  }
}