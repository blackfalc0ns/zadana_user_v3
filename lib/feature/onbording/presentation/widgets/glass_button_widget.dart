import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class GlassButtonWidget extends StatelessWidget {
  final String text;
  final bool isSecondary;
  final VoidCallback? onPressed;

  const GlassButtonWidget({
    super.key,
    required this.text,
    this.isSecondary = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Spacing.buttonRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              offset: const Offset(0, 8),
              blurRadius: 24,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Spacing.buttonRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: isSecondary
                    ? Colors.transparent
                    : color.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(Spacing.buttonRadius),
                border: Border.all(
                  color: color.surface.withValues(alpha: isSecondary ? 0.5 : 0.3),
                  width: 0.5,
                ),
              ),
              child: Center(
                child: Text(
                  text,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    color: color.surface.withValues(alpha: 0.85),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
