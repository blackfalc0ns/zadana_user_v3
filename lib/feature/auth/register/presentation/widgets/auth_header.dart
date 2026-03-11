import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/constants/app_constants.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

/// Header widget with logo and welcome text
/// Following .ai_rules.md:
/// - Uses AppConstants for assets
/// - Uses context.textTheme
/// - Uses ColorScheme
/// - No hardcoded colors
/// - Line length ≤ 80
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Center(
          child: Image.asset(
            AppConstants.logoLight,
            height: 80,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: Spacing.xl),

        // Welcome text
        Text(
          locale.auth_title,
          style: textTheme.headlineMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: Spacing.sm),

        // Subtitle
        Text(
          locale.auth_subtitle_signup,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
