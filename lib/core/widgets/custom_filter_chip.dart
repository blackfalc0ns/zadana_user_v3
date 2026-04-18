import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class CustomFilterChip extends StatelessWidget {
  const CustomFilterChip({
    super.key,
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.backgroundColor,
    this.selectedColor,
    this.borderColor,
    this.textStyle,
  });

  final String label;
  final String? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? borderColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.xs,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGrey),
          boxShadow: [
            BoxShadow(
              color: color.shadow.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          color: isSelected
              ? (selectedColor ?? color.primary)
              : (AppColors.white),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Text(
                icon!,
                style: const TextStyle(fontSize: 12),
              ), // تقليل من 14 إلى 12
              const SizedBox(width: 3), // تقليل من 4 إلى 3
            ],
            Text(
              label,
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                color: isSelected ? color.onPrimary : color.onSurface,
              ).merge(textStyle),
            ),
          ],
        ),
      ),
    );
  }
}
