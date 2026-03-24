import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/constants/app_constants.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
          l10n.help_support,
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
            _buildHelpSection(l10n, color),
            const SizedBox(height: Spacing.xl),
            _buildContactSection(l10n, color),
            const SizedBox(height: Spacing.xl),
            _buildFAQSection(l10n, color),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection(AppLocalizations l10n, ColorScheme color) {
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.sm),
        border: Border.all(
          color: color.outline,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.help_outline,
            size: 48,
            color: color.primary,
          ),
          const SizedBox(height: Spacing.md),
          Text(
            l10n.help_support,
            style: getBoldStyle(
              fontSize: FontSize.size18,
              fontFamily: FontConstant.cairo,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            'نحن هنا لمساعدتك على مدار الساعة',
            style: getMediumStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
              color: color.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(AppLocalizations l10n, ColorScheme color) {
    return Column(
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
        _buildContactButton(
          icon: FontAwesomeIcons.whatsapp,
          title: 'WhatsApp',
          subtitle: 'تواصل معنا عبر واتساب',
          onTap: () => _launchUrl('https://wa.me/${AppConstants.developerWhatsapp}'),
          color: color,
        ),
        const SizedBox(height: Spacing.sm),
        _buildContactButton(
          icon: FontAwesomeIcons.envelope,
          title: 'Email',
          subtitle: 'أرسل لنا بريد إلكتروني',
          onTap: () => _launchUrl('mailto:${AppConstants.developerEmail}'),
          color: color,
        ),
        const SizedBox(height: Spacing.sm),
        _buildContactButton(
          icon: FontAwesomeIcons.phone,
          title: 'Phone',
          subtitle: 'اتصل بنا مباشرة',
          onTap: () => _launchUrl('tel:${AppConstants.developerPhone}'),
          color: color,
        ),
      ],
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ColorScheme color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
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
            Container(
              padding: const EdgeInsets.all(Spacing.sm),
              decoration: BoxDecoration(
                color: color.primaryContainer,
                borderRadius: BorderRadius.circular(Spacing.xs),
              ),
              child: FaIcon(
                icon,
                size: 20,
                color: color.primary,
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getBoldStyle(
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: getMediumStyle(
                      fontSize: FontSize.size12,
                      fontFamily: FontConstant.cairo,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: color.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection(AppLocalizations l10n, ColorScheme color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.faq,
          style: getBoldStyle(
            fontSize: FontSize.size16,
            fontFamily: FontConstant.cairo,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.md),
        _buildFAQItem(
          question: 'كيف يمكنني تتبع طلبي؟',
          answer: 'يمكنك تتبع طلبك من خلال قسم "طلباتي" في التطبيق',
          color: color,
        ),
        const SizedBox(height: Spacing.sm),
        _buildFAQItem(
          question: 'ما هي طرق الدفع المتاحة؟',
          answer: 'نقبل الدفع بالبطاقة الائتمانية، مدى، وأبل باي',
          color: color,
        ),
        const SizedBox(height: Spacing.sm),
        _buildFAQItem(
          question: 'كيف يمكنني إرجاع منتج؟',
          answer: 'يمكنك طلب الإرجاع من خلال صفحة تفاصيل الطلب خلال 14 يوم',
          color: color,
        ),
      ],
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
    required ColorScheme color,
  }) {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.sm),
        border: Border.all(
          color: color.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline,
                size: 20,
                color: color.primary,
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Text(
                  question,
                  style: getBoldStyle(
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                    color: color.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            answer,
            style: getMediumStyle(
              fontSize: FontSize.size13,
              fontFamily: FontConstant.cairo,
              color: color.onSurfaceVariant,
            ),
          ),
        ],
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
