import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class TextButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const TextButtonWidget({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    
    return Text(
      text,
      style: getMediumStyle(
        fontFamily: FontConstant.cairo,
        color: color.surface.withValues(alpha: 0.9),
        fontSize: 16,
      ),
    );
  }
}
