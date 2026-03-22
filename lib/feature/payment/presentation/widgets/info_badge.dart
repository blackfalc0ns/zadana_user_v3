import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';

class InfoBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const InfoBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.xs,
          ),
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: getMediumStyle(
          fontSize: fontSize ?? FontSize.size11,
          fontFamily: FontConstant.cairo,
          color: textColor ?? colors.secondary,
        ),
      ),
    );
  }
}
