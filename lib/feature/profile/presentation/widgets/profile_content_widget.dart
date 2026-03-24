import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/language_selector.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_card.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_menu_tile.dart';

/// Main content widget for profile screen
class ProfileContent extends StatelessWidget {
  final AppLocalizations l10n;
  final VoidCallback onLogout;

  const ProfileContent({super.key, required this.l10n, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: Spacing.lg),
          ProfileCard(
            userName: 'محمد أحمد',
            userPhone: '+966 50 123 4567',
            onEditTap: () {
              Navigator.of(context).pushNamed(AppRoutes.editProfile);
            },
          ),
          const SizedBox(height: Spacing.lg),
          _buildMenuSection(context, color),
          const SizedBox(height: Spacing.xxxl),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, ColorScheme color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      child: Column(
        children: [
          ProfileMenuTile(
            icon: Iconsax.location,
            title: l10n.addresses,
            iconColor: color.onSurface,
            onTap: () {},
          ),
          ProfileMenuTile(
            icon: Iconsax.heart,
            title: l10n.nav_orders,
            iconColor: color.onSurface,
            onTap: () {},
          ),
          ProfileMenuTile(
            icon: Iconsax.global,
            title: l10n.language,
            iconColor: color.onSurface,
            trailing: Text(
              'العربية',
              style: getMediumStyle(
                fontSize: FontSize.size13,
                fontFamily: FontConstant.cairo,
                color: color.onSurface,
              ),
            ),
            onTap: () => showLanguageBottomSheet(
              context: context,
              selectedLanguage: 'ar',
              onLanguageSelected: (lang) {
                // TODO: Change language
              },
            ),
          ),
          ProfileMenuTile(
            icon: Iconsax.notification,
            title: l10n.notifications,
            iconColor: color.onSurface,
            onTap: () {},
          ),
          ProfileMenuTile(
            icon: Iconsax.lock,
            title: l10n.change_password,
            iconColor: color.onSurface,
            onTap: () {},
          ),
          ProfileMenuTile(
            icon: Iconsax.support,
            title: l10n.help_support,
            iconColor: color.onSurface,
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.helpSupport);
            },
          ),
          ProfileMenuTile(
            icon: Iconsax.info_circle,
            title: l10n.about_app,
            iconColor: color.onSurface,
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.aboutApp);
            },
          ),
          ProfileMenuTile(
            icon: Iconsax.logout,
            title: l10n.logout,
            iconColor: color.error,
            onTap: () {
              // TODO: Implement logout
            },
          ),
        ],
      ),
    );
  }
}
