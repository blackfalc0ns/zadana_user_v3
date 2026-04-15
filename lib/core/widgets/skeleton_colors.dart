import 'package:flutter/material.dart';

class SkeletonColors {
  SkeletonColors._();

  static Color base(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Color.alphaBlend(
      color.onSurface.withValues(alpha: 0.06),
      color.surfaceContainerHighest,
    );
  }

  static Color highlight(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Color.alphaBlend(
      color.onSurface.withValues(alpha: 0.03),
      color.surface,
    );
  }

  static Color card(BuildContext context) {
    return Theme.of(context).colorScheme.surfaceContainerLowest;
  }

  static Color border(BuildContext context) {
    return Theme.of(context).colorScheme.outlineVariant;
  }
}
