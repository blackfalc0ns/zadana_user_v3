import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/core/widgets/drawer/drawer_footer_components.dart';

class DrawerFooter extends StatelessWidget {
  const DrawerFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border(
          top: BorderSide(color: color.outline.withValues(alpha: 0.14)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton.outlined(
            height: 40,
            text: locale.logout,
            color: AppColors.error,
            textColor: AppColors.error,
            onPressed: () => showLogoutDialog(context),
          ),
          const SizedBox(height: Spacing.xss),
          FooterInfoTile(
            onTap: () => showDeveloperDialog(context),
          ),
          const SizedBox(height: Spacing.xss),
        ],
      ),
    );
  }
}
