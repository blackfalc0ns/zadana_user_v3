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
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth;
        final compact = itemWidth < 84;
        final iconSize = compact ? 18.0 : 22.0;
        final labelFontSize = compact ? FontSize.size11 : FontSize.size12;
        final contentPadding = EdgeInsets.symmetric(
          horizontal: compact ? 4 : 6,
          vertical: compact ? 6 : 8,
        );

        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: contentPadding,
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
                  Text(icon!, style: TextStyle(fontSize: iconSize)),
                ],
                SizedBox(height: compact ? 4 : 6),
                Text(
                  label,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: labelFontSize,
                    color: isSelected ? color.onPrimary : color.onSurface,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
