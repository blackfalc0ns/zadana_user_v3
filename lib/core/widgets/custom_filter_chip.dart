import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
           horizontal: Spacing.md,
          vertical: Spacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedColor ?? AppColors.primary)
              : (backgroundColor ?? AppColors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (selectedColor ?? AppColors.primary)
                : (color.outline.withValues(alpha: 0.2)),
            width: 1,
          ),
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
              style:
                  textStyle ??
                  AppTextStyles.labelSmall.copyWith(
                    color: isSelected ? AppColors.white : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
