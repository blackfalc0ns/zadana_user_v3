import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/constants/app_constants.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/contact_button.dart';

/// Contact section widget
class ContactSection extends StatelessWidget {
  final AppLocalizations l10n;

  const ContactSection({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.contact_us,
            style: getBoldStyle(
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.md),
          ContactButton(
            icon: FontAwesomeIcons.whatsapp,
            title: 'WhatsApp',
            subtitle: 'تواصل معنا عبر واتساب',
            onTap: () => _launchUrl('https://wa.me/${AppConstants.developerWhatsapp}'),
            iconColor: const Color(0xFF25D366),
          ),
          const SizedBox(height: Spacing.sm),
          ContactButton(
            icon: FontAwesomeIcons.envelope,
            title: 'Email',
            subtitle: AppConstants.developerEmail,
            onTap: () => _launchUrl('mailto:${AppConstants.developerEmail}'),
            iconColor: const Color(0xFFEA4335),
          ),
          const SizedBox(height: Spacing.sm),
          ContactButton(
            icon: FontAwesomeIcons.phone,
            title: 'Phone',
            subtitle: 'اتصل بنا مباشرة',
            onTap: () => _launchUrl('tel:${AppConstants.developerPhone}'),
            iconColor: const Color(0xFF4285F4),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // TODO: Show error message
    }
  }
}
