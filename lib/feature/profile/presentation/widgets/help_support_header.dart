import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

/// Help support header widget
class HelpSupportHeader extends StatelessWidget {
  const HelpSupportHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.xl),
      decoration: BoxDecoration(
        color: color.primaryContainer,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.support_agent,
            size: 40,
            color: color.onSecondary,
          ),
          const SizedBox(height: Spacing.md),
          Text(
            'كيف يمكننا مساعدتك؟',
            style: getBoldStyle(
              fontSize: FontSize.size18,
              fontFamily: FontConstant.cairo,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            'تواصل معنا وسنرد على استفسارك قريباً',
            style: getMediumStyle(
              fontSize: FontSize.size13,
              fontFamily: FontConstant.cairo,
              color: color.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
