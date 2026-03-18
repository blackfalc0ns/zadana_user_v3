import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          text,
          style: getMediumStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
            color: color.onSurface,
          ),
        ),
      ),
    );
  }
}