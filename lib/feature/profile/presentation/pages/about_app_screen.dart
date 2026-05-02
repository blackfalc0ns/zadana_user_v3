import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/utils/app_package_info.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = context.colorScheme;

    return Scaffold(
      backgroundColor: color.surfaceContainerLowest,
      appBar: CustomAppBar(title: l10n.about_app_title),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          Spacing.lg,
          Spacing.base,
          Spacing.lg,
          Spacing.xl,
        ),
        child: Column(
          children: [
            Image.asset(Assets.logoDark, width: 120, height: 120),
            const SizedBox(height: Spacing.lg),
            Text(
              l10n.app_name,
              style: getBoldStyle(
                fontSize: FontSize.size22,
                fontFamily: FontConstant.cairo,
                color: color.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.xs),
            FutureBuilder<String>(
              future: AppPackageInfo.versionName,
              builder: (context, snapshot) {
                final version = snapshot.data ?? '...';
                return Text(
                  '${l10n.version_label} v$version',
                  style: getMediumStyle(
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                    color: color.onSurfaceVariant,
                  ),
                );
              },
            ),
            const SizedBox(height: Spacing.xl),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Spacing.lg),
              decoration: BoxDecoration(
                color: color.surface,
                borderRadius: BorderRadius.circular(Spacing.cardRadius),
              ),
              child: Text(
                l10n.app_description,
                style: getMediumStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: color.onSurfaceVariant,
                  //  height: 1.7,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: Spacing.xl),
          ],
        ),
      ),
    );
  }
}
