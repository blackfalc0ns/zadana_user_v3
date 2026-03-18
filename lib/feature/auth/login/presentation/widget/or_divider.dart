import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 1,
            color: color.outline.withValues(alpha: 0.2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          child: Text(
            label,
            style: getRegularStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
              color: color.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1,
            color: color.outline.withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }
}