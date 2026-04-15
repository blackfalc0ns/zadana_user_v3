import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class CircleActionButton extends StatelessWidget {
  const CircleActionButton({
    super.key,
    required this.icon,
    required this.onTap,
  });
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Material(
      color: color.surfaceContainerLowest,
      elevation: 2,
      shadowColor: color.shadow.withValues(alpha: 0.14),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: color.onSurface, size: 22),
        ),
      ),
    );
  }
}
