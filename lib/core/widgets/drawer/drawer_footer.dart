import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/core/widgets/drawer/drawer_footer_components.dart';
import 'package:zadana_user_v3/core/widgets/skeleton_colors.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/shimmer_wrapper.dart';
import 'package:zadana_user_v3/feature/profile/data/models/platform_contact_dto.dart';
import 'package:zadana_user_v3/feature/profile/data/platform_contact_loader.dart';

class DrawerFooter extends StatefulWidget {
  const DrawerFooter({super.key, required this.isGuest});

  final bool isGuest;

  @override
  State<DrawerFooter> createState() => _DrawerFooterState();
}

class _DrawerFooterState extends State<DrawerFooter> {
  late final Future<PlatformContactDto> _contact = PlatformContactLoader.load();

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;
    final bottomPadding = MediaQuery.paddingOf(context).bottom + Spacing.md;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        Spacing.base,
        0,
        Spacing.base,
        bottomPadding,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border(
          top: BorderSide(color: color.outline.withValues(alpha: 0.14)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.isGuest) ...[
            AppButton.outlined(
              height: 40,
              text: locale.login,
              color: color.primary,
              textColor: color.primary,
              onPressed: () {
                Navigator.pop(context);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!context.mounted) return;
                  Navigator.of(context).pushNamed(AppRoutes.login);
                });
              },
            ),
            const SizedBox(height: Spacing.xss),
          ] else ...[
            AppButton.outlined(
              height: 40,
              text: locale.logout,
              color: AppColors.error,
              textColor: AppColors.error,
              onPressed: () => showLogoutDialog(context),
            ),
            const SizedBox(height: Spacing.xss),
          ],
          FutureBuilder<PlatformContactDto>(
            future: _contact,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: Spacing.xss),
                  child: _SocialMediaSkeleton(),
                );
              }
              final contact = snapshot.data;
              if (contact == null) return const SizedBox.shrink();
              final socialButtons = _socialButtons(contact);
              if (socialButtons.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: Spacing.xss),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: Spacing.md,
                  runSpacing: Spacing.xss,
                  children: socialButtons,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _socialButtons(PlatformContactDto contact) {
    final entries = [
      (
        'X',
        FontAwesomeIcons.xTwitter,
        const Color(0xFF000000),
        contact.twitterUrl,
      ),
      (
        'Instagram',
        FontAwesomeIcons.instagram,
        const Color(0xFFE1306C),
        contact.instagramUrl,
      ),
      (
        'TikTok',
        FontAwesomeIcons.tiktok,
        const Color(0xFF000000),
        contact.tikTokUrl,
      ),
      (
        'Snapchat',
        FontAwesomeIcons.snapchat,
        const Color(0xFFFFFC00),
        contact.snapchatUrl,
      ),
      (
        'Facebook',
        FontAwesomeIcons.facebookF,
        const Color(0xFF1877F2),
        contact.facebookUrl,
      ),
      (
        'YouTube',
        FontAwesomeIcons.youtube,
        const Color(0xFFFF0000),
        contact.youTubeUrl,
      ),
      (
        'LinkedIn',
        FontAwesomeIcons.linkedinIn,
        const Color(0xFF0A66C2),
        contact.linkedInUrl,
      ),
    ];

    return entries
        .where((entry) => _isHttpUrl(entry.$4))
        .map(
          (entry) => _SocialMediaButton(
            tooltip: entry.$1,
            icon: entry.$2,
            brandColor: entry.$3,
            url: entry.$4!,
          ),
        )
        .toList();
  }

  bool _isHttpUrl(String? value) {
    if (value == null || value.trim().isEmpty) return false;
    final uri = Uri.tryParse(value);
    return uri != null && (uri.scheme == 'https' || uri.scheme == 'http');
  }
}

class _SocialMediaSkeleton extends StatelessWidget {
  const _SocialMediaSkeleton();

  @override
  Widget build(BuildContext context) {
    final base = SkeletonColors.base(context);
    return ShimmerWrapper(
      isLoading: true,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: Spacing.md,
        runSpacing: Spacing.xss,
        children: List.generate(
          7,
          (_) => Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: base, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}

class _SocialMediaButton extends StatelessWidget {
  const _SocialMediaButton({
    required this.tooltip,
    required this.icon,
    required this.brandColor,
    required this.url,
  });

  final String tooltip;
  final FaIconData icon;
  final Color brandColor;
  final String url;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: color.surfaceContainerHighest,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () =>
              launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Center(child: FaIcon(icon, size: 22, color: brandColor)),
          ),
        ),
      ),
    );
  }
}
