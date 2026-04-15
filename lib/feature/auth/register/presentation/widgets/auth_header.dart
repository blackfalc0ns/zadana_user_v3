import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(Assets.logoLight, height: 80, fit: BoxFit.contain),
        ),
        const SizedBox(height: Spacing.xl),

        Text(
          locale.auth_title,
          style: getBoldStyle(
            fontSize: FontSize.size24,
            fontFamily: FontConstant.cairo,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.sm),

        Text(
          locale.auth_subtitle_signup,
          style: getRegularStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
            color: color.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
