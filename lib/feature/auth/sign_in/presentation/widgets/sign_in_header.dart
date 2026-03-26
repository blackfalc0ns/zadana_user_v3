import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class SignInHeader extends StatelessWidget {
  const SignInHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with back button, title and description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.primary.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    Iconsax.arrow_left_2,
                    color: color.onSurface,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.lg),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(Assets.authGrocery, width: 100),
            Column(
              spacing: 5,
              children: [
                Text(
                  locale.auth_title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    color: color.primary,
                    fontSize: 30,
                  ),
                ),
                Text(
                  locale.auth_subtitle_login,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),

        const SizedBox(height: Spacing.xl),
      ],
    );
  }
}
