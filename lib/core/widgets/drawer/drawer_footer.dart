import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/constants/app_constants.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/core/widgets/drawer/drawer_footer_components.dart';

class DrawerFooter extends StatelessWidget {
  const DrawerFooter({super.key, required this.isGuest});

  final bool isGuest;

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
          if (isGuest) ...[
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
          const SizedBox(
            width: double.infinity,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SocialMediaButton(
                    tooltip: 'X',
                    icon: FontAwesomeIcons.xTwitter,
                    brandColor: Color(0xFF000000),
                    url: AppConstants.xUrl,
                  ),
                  SizedBox(width: Spacing.md),
                  _SocialMediaButton(
                    tooltip: 'Instagram',
                    icon: FontAwesomeIcons.instagram,
                    brandColor: Color(0xFFE1306C),
                    url: AppConstants.instagramUrl,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Spacing.xss),
          FooterInfoTile(onTap: () => showDeveloperDialog(context)),
          const SizedBox(height: Spacing.xss),
        ],
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
