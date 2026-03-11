import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

/// Header widget for reset password screen
/// Following .ai_rules.md:
/// - Uses context.textTheme
/// - Uses ColorScheme
/// - No hardcoded colors
/// - Line length ≤ 80
class ResetPasswordHeader extends StatelessWidget {
  final String identifier;

  const ResetPasswordHeader({
    super.key,
    required this.identifier,
  });

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
          locale.reset_password_title,
          style: textTheme.headlineMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: Spacing.sm),

        // Description
        Text(
          '${locale.reset_password_description_prefix} $identifier',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
