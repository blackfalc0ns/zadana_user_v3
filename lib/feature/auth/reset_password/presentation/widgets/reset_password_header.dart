import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class ResetPasswordHeader extends StatelessWidget {
  final String identifier;

  const ResetPasswordHeader({
    super.key,
    required this.identifier,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.reset_password_title,
          style: getBoldStyle(
            fontSize: FontSize.size24,
            fontFamily: FontConstant.cairo,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.sm),

        Text(
          '${locale.reset_password_description_prefix} $identifier',
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
