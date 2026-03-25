import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class CustomVerticalFilterChip extends StatelessWidget {
  const CustomVerticalFilterChip({
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
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedColor ?? AppColors.primary)
              : (backgroundColor ?? AppColors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (selectedColor ?? AppColors.primary)
                : (color.outline.withValues(alpha: 0.2)),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Text(icon!, style: const TextStyle(fontSize: 22)),
            ],
            const SizedBox(height: 6),

            Text(
              label,
              style:
                getSemiBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size12,
                  color: isSelected ? color.onPrimary : color.onSurface,
                ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
