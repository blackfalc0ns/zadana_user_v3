import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

/// Header widget for forgot password screen
/// Following .ai_rules.md:
/// - Uses context.textTheme
/// - Uses ColorScheme
/// - No hardcoded colors
/// - Line length ≤ 80
class ForgetPasswordHeader extends StatelessWidget {
  const ForgetPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          locale.forget_password_title,
          style: textTheme.headlineMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: Spacing.sm),

        // Description
        Text(
          locale.forget_password_description,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
