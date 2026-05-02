import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/general_cubit/local_cubit.dart';
import 'package:zadana_user_v3/core/utils/app_package_info.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';

class DrawerDialogs {
  static void showLanguageDialog(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;
    final selectedLanguage = context
        .read<LocaleThemeCubit>()
        .state
        .locale
        .languageCode;

    showModalBottomSheet(
      context: context,
      backgroundColor: color.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Container(
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
                fontSize: FontSize.size17,
                fontFamily: FontConstant.cairo,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.lg),
            _LanguageTile(
              label: locale.arabic,
              code: 'ar',
              selectedLanguage: selectedLanguage,
              onTap: () async {
                await context.read<LocaleThemeCubit>().setArabic();
                if (sheetContext.mounted) {
                  Navigator.pop(sheetContext);
                }
              },
            ),
            _LanguageTile(
              label: locale.english,
              code: 'en',
              selectedLanguage: selectedLanguage,
              onTap: () async {
                await context.read<LocaleThemeCubit>().setEnglish();
                if (sheetContext.mounted) {
                  Navigator.pop(sheetContext);
                }
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
                FutureBuilder<String>(
                  future: AppPackageInfo.versionName,
                  builder: (context, snapshot) {
                    final version = snapshot.data ?? '...';
                    return Text(
                      '${locale.version_label}: v$version',
                      style: getRegularStyle(
                        fontSize: FontSize.size14,
                        fontFamily: FontConstant.cairo,
                        color: color.onSurface.withValues(alpha: 0.7),
                      ),
                    );
                  },
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

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.label,
    required this.code,
    required this.selectedLanguage,
    required this.onTap,
  });

  final String label;
  final String code;
  final String selectedLanguage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final isSelected = selectedLanguage == code;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: getMediumStyle(
          fontSize: FontSize.size16,
          fontFamily: FontConstant.cairo,
          color: color.onSurface,
        ),
      ),
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: color.primary.withValues(alpha: 0.1),
        child: Text(
          code.toUpperCase(),
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            color: color.primary,
          ),
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: color.primary)
          : null,
      onTap: onTap,
    );
  }
}
