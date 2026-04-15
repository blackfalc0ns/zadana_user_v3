import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';

class IconContainer extends StatelessWidget {
  const IconContainer({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.size,
    this.padding,
  });
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: padding ?? const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Spacing.sm),
      ),
      child: Icon(icon, color: iconColor ?? colors.primary, size: size ?? 20),
    );
  }
}
