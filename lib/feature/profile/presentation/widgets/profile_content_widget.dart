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

class ProfileContent extends StatelessWidget {
  const ProfileContent({
    super.key,
    required this.l10n,
    required this.onLogout,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
  });

  final AppLocalizations l10n;
  final VoidCallback onLogout;
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final langCode = Localizations.localeOf(context).languageCode;
    final items =
        <({
          IconData icon,
          String title,
          Color iconColor,
          Widget? trailing,
          VoidCallback onTap,
        })>[
          (
            icon: Iconsax.location,
            title: l10n.addresses,
            iconColor: color.onSurface,
            trailing: null,
            onTap: () {},
          ),
          (
            icon: Iconsax.shopping_cart,
            title: l10n.nav_orders,
            iconColor: color.onSurface,
            trailing: null,
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.myOrdersPage),
          ),
          (
            icon: Iconsax.global,
            title: l10n.language,
            iconColor: color.onSurface,
            trailing: Text(
              langCode == 'ar' ? 'العربية' : 'English',
              style: getMediumStyle(
                fontSize: FontSize.size13,
                fontFamily: FontConstant.cairo,
                color: color.onSurfaceVariant,
              ),
            ),
            onTap: () => showLanguageBottomSheet(
              context: context,
              selectedLanguage: langCode,
              onLanguageSelected: (_) {},
            ),
          ),
          (
            icon: Iconsax.notification,
            title: l10n.notifications,
            iconColor: color.onSurface,
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: onNotificationsChanged,
            ),
            onTap: () => onNotificationsChanged(!notificationsEnabled),
          ),
          (
            icon: Iconsax.lock,
            title: l10n.change_password,
            iconColor: color.onSurface,
            trailing: null,
            onTap: () {},
          ),
          (
            icon: Iconsax.support,
            title: l10n.help_support,
            iconColor: color.onSurface,
            trailing: null,
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.helpSupport),
          ),
          (
            icon: Iconsax.info_circle,
            title: l10n.about_app,
            iconColor: color.onSurface,
            trailing: null,
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.aboutApp),
          ),
          (
            icon: Iconsax.logout,
            title: l10n.logout,
            iconColor: color.error,
            trailing: null,
            onTap: onLogout,
          ),
        ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
        child: Column(
          children: [
            ProfileCard(
              userName: 'محمد أحمد',
              userPhone: '+966 50 123 4567',
              onEditTap:
                  () => Navigator.of(context).pushNamed(AppRoutes.editProfile),
            ),
            const SizedBox(height: Spacing.lg),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
                child: ProfileMenuTile(
                  icon: item.icon,
                  title: item.title,
                  iconColor: item.iconColor,
                  trailing: item.trailing,
                  onTap: item.onTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
