import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';

class AppButtonSwitch extends StatelessWidget {
  const AppButtonSwitch({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final isDisabled = onPressed == null || isLoading;

    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.primary, color.primary.withValues(alpha: 0.82)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (!isDisabled)
              BoxShadow(
                color: color.primary.withValues(alpha: 0.20),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
          ],
        ),
        child: AppButton(onPressed: isDisabled ? null : onPressed, text: label),
      ),
    );
  }
}
