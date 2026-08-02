import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key, this.secondaryText});
  final String text;
  final String? secondaryText;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final primaryStyle = getMediumStyle(
      fontSize: FontSize.size14,
      fontFamily: FontConstant.cairo,
      color: color.onSurface,
    );
    final secondaryStyle = primaryStyle.copyWith(
      fontWeight: FontWeight.w300,
      color: color.onSurface.withAlpha((0.6 * 255).toInt()),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
        child: secondaryText == null
            ? Text(text, textAlign: TextAlign.start, style: primaryStyle)
            : RichText(
                text: TextSpan(
                  style: primaryStyle,
                  children: [
                    TextSpan(text: text),
                    TextSpan(text: ' $secondaryText', style: secondaryStyle),
                  ],
                ),
              ),
      ),
    );
  }
}
