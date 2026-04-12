import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';

class DrawerDialogs {
  static void showLanguageDialog(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: color.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: Spacing.md),
              decoration: BoxDecoration(
                color: color.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Text(
              locale.select_language,
              style: getBoldStyle(
                fontSize: FontSize.size20,
                fontFamily: FontConstant.cairo,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.lg),

            ListTile(
              title: Text(
                locale.arabic,
                style: getMediumStyle(
                  fontSize: FontSize.size16,
                  fontFamily: FontConstant.cairo,
                  color: color.onSurface,
                ),
              ),
              leading: const Text('🇸🇦', style: TextStyle(fontSize: 24)),
              trailing: Icon(Icons.check, color: color.primary),
              onTap: () {
                Navigator.pop(context);
                // TODO: Change language to Arabic
              },
            ),
            ListTile(
              title: Text(
                locale.english,
                style: getMediumStyle(
                  fontSize: FontSize.size16,
                  fontFamily: FontConstant.cairo,
                  color: color.onSurface,
                ),
              ),
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
              onTap: () {
                Navigator.pop(context);
                // TODO: Change language to English
              },
            ),

            const SizedBox(height: Spacing.md),
          ],
        ),
      ),
    );
  }

  static void showAboutDialog(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: color.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: Spacing.md),
              decoration: BoxDecoration(
                color: color.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Text(
              locale.about_app_title,
              style: getBoldStyle(
                fontSize: FontSize.size20,
                fontFamily: FontConstant.cairo,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.lg),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locale.app_name,
                  style: getMediumStyle(
                    fontSize: FontSize.size16,
                    fontFamily: FontConstant.cairo,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  '${locale.version_label}: v1.0.0',
                  style: getRegularStyle(
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                    color: color.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  '${locale.release_date}: 2024',
                  style: getRegularStyle(
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                    color: color.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  locale.app_description,
                  style: getRegularStyle(
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                    color: color.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),

            const SizedBox(height: Spacing.lg),

            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: () => Navigator.pop(context),

                text: locale.ok,
              ),
            ),

            const SizedBox(height: Spacing.md),
          ],
        ),
      ),
    );
  }
}

