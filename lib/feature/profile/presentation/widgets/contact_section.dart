import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/skeleton_colors.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/shimmer_wrapper.dart';
import 'package:zadana_user_v3/feature/profile/data/models/platform_contact_dto.dart';
import 'package:zadana_user_v3/feature/profile/data/platform_contact_loader.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/contact_button.dart';

/// Contact section widget
class ContactSection extends StatefulWidget {
  const ContactSection({super.key, required this.l10n});
  final AppLocalizations l10n;

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  late final Future<PlatformContactDto> _contact = PlatformContactLoader.load();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.l10n.contact_us,
            style: getBoldStyle(
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.md),
          FutureBuilder<PlatformContactDto>(
            future: _contact,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const _ContactSectionSkeleton();
              }
              final contact = snapshot.data;
              if (contact == null) return Text(widget.l10n.not_available);
              final items = <Widget>[
                if (_hasValue(contact.whatsAppUrl))
                  ContactButton(
                    icon: FontAwesomeIcons.whatsapp,
                    title: widget.l10n.contact_whatsapp,
                    subtitle: _whatsAppSubtitle(contact),
                    onTap: () => _launchUrl(contact.whatsAppUrl!),
                    iconColor: const Color(0xFF25D366),
                  ),
                if (_hasValue(contact.supportEmail))
                  ContactButton(
                    icon: FontAwesomeIcons.envelope,
                    title: widget.l10n.label_email,
                    subtitle: contact.supportEmail!,
                    onTap: () => _launchUrl('mailto:${contact.supportEmail}'),
                    iconColor: const Color(0xFFEA4335),
                  ),
                if (_hasValue(contact.supportPhone))
                  ContactButton(
                    icon: FontAwesomeIcons.phone,
                    title: widget.l10n.phone,
                    subtitle: contact.supportPhone!,
                    onTap: () => _launchUrl('tel:${contact.supportPhone}'),
                    iconColor: const Color(0xFF4285F4),
                  ),
              ];
              if (items.isEmpty) return Text(widget.l10n.not_available);
              return Column(
                children: [
                  for (var index = 0; index < items.length; index++) ...[
                    items[index],
                    if (index < items.length - 1)
                      const SizedBox(height: Spacing.sm),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;

  String _whatsAppSubtitle(PlatformContactDto contact) =>
      _hasValue(contact.supportPhone)
      ? contact.supportPhone!
      : contact.whatsAppUrl!;

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (url.scheme != 'mailto' &&
        url.scheme != 'tel' &&
        (url.scheme != 'https' && url.scheme != 'http')) {
      return;
    }
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}

class _ContactSectionSkeleton extends StatelessWidget {
  const _ContactSectionSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _ContactSkeletonCard(),
        SizedBox(height: Spacing.sm),
        _ContactSkeletonCard(),
        SizedBox(height: Spacing.sm),
        _ContactSkeletonCard(),
      ],
    );
  }
}

class _ContactSkeletonCard extends StatelessWidget {
  const _ContactSkeletonCard();

  @override
  Widget build(BuildContext context) {
    final base = SkeletonColors.base(context);
    return ShimmerWrapper(
      isLoading: true,
      child: Container(
        height: 78,
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(Spacing.md),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: base,
                borderRadius: BorderRadius.circular(Spacing.sm),
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 76, height: 14, color: base),
                const SizedBox(height: Spacing.sm),
                Container(width: 144, height: 12, color: base),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
