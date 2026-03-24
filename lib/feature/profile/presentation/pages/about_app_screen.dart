import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/constants/app_constants.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = context.colorScheme;

    return Scaffold(
      backgroundColor: color.background,
      appBar: AppBar(
        backgroundColor: color.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: color.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.about_app_title,
          style: getMediumStyle(
            fontSize: FontSize.size18,
            fontFamily: FontConstant.cairo,
            color: color.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          children: [
            Image.asset(
              Assets.logo,
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.app_name,
              style: getBoldStyle(
                fontSize: FontSize.size22,
                fontFamily: FontConstant.cairo,
                color: color.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${l10n.version_label} ${AppConstants.appVersion}',
              style: getMediumStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: color.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Spacing.xl),
            Text(
              l10n.app_description,
              style: getMediumStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: color.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.xl),
            _buildDeveloperSection(l10n, color),
          ],
        ),
      ),
    );
  }

  Widget _buildDeveloperSection(AppLocalizations l10n, ColorScheme color) {
    return Column(
      children: [
        Image.asset(
          Assets.blackFalcons,
          width: 60,
          height: 60,
        ),
        const SizedBox(height: Spacing.md),
        Text(
          'Black Falcons',
          style: getBoldStyle(
            fontSize: FontSize.size18,
            fontFamily: FontConstant.cairo,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Text(
          l10n.developer,
          style: getMediumStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
            color: color.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: Spacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildContactButton(
              icon: FontAwesomeIcons.whatsapp,
              label: 'WhatsApp',
              onTap: () => _launchUrl('https://wa.me/${AppConstants.developerWhatsapp}'),
              color: color,
            ),
            const SizedBox(width: Spacing.md),
            _buildContactButton(
              icon: FontAwesomeIcons.envelope,
              label: 'Email',
              onTap: () => _launchUrl('mailto:${AppConstants.developerEmail}'),
              color: color,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ColorScheme color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.lg,
          vertical: Spacing.md,
        ),
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: BorderRadius.circular(Spacing.sm),
          border: Border.all(
            color: color.outline,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            FaIcon(
              icon,
              size: 18,
              color: color.onSurface,
            ),
            const SizedBox(width: Spacing.xs),
            Text(
              label,
              style: getMediumStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: color.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
