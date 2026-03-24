import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = context.colorScheme;

    return Scaffold(
      backgroundColor: color.background,
      appBar: AppBar(
        backgroundColor: color.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.profile_title,
          style: getMediumStyle(
            fontSize: FontSize.size18,
            fontFamily: FontConstant.cairo,
            color: color.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: Spacing.sm),
            _buildProfileCard(context, color),
            const SizedBox(height: Spacing.sm),
            _buildMenuList(l10n, context, color),
            const SizedBox(height: Spacing.base),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, ColorScheme color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(AppRoutes.editProfile);
        },
        child: Container(
          padding: const EdgeInsets.all(Spacing.sm),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: color.primaryContainer,
                    child: Text(
                      'م',
                      style: getBoldStyle(
                        fontSize: FontSize.size20,
                        fontFamily: FontConstant.cairo,
                        color: color.primary,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: color.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: color.background, width: 1.5),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.pen,
                        size: 8,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'محمد أحمد',
                      style: getBoldStyle(
                        fontSize: FontSize.size16,
                        fontFamily: FontConstant.cairo,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '+966 50 123 4567',
                      style: getMediumStyle(
                        fontSize: FontSize.size13,
                        fontFamily: FontConstant.cairo,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuList(AppLocalizations l10n, BuildContext context, ColorScheme color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      child: Column(
        children: [
          _buildMenuTile(
            icon: Iconsax.location,
            title: l10n.addresses,
            iconColor: color.onSurface,
            onTap: () {},
          ),
          _buildMenuTile(
            icon: Iconsax.heart,
            title: l10n.nav_orders,
            iconColor: color.onSurface,
            onTap: () {},
          ),
          const SizedBox(height: Spacing.xs),
          _buildMenuTile(
            icon: Iconsax.global,
            title: l10n.language,
            iconColor: color.onSurface,
            trailing: Text(
              'العربية',
              style: getMediumStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: color.onSurfaceVariant,
              ),
            ),
            onTap: () => _showLanguageBottomSheet(context, color, l10n),
          ),
          _buildMenuTile(
            icon: Iconsax.notification,
            title: l10n.notifications,
            iconColor: color.onSurface,
            onTap: () {},
          ),
          _buildMenuTile(
            icon: Iconsax.lock,
            title: l10n.change_password,
            iconColor: color.onSurface,
            onTap: () {},
          ),
          _buildMenuTile(
            icon: Iconsax.info_circle,
            title: l10n.help_support,
            iconColor: color.onSurface,
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.helpSupport);
            },
          ),
          _buildMenuTile(
            icon: Iconsax.document,
            title: l10n.about_app,
            iconColor: color.onSurface,
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.aboutApp);
            },
          ),
          _buildMenuTile(
            icon: Iconsax.logout,
            title: l10n.logout,
            iconColor: color.error,
            onTap: () {},
          ),
          SizedBox(height: Spacing.lg),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required Color iconColor,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.xs),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: iconColor.withOpacity(0.2),
            width: 0.5,
          ),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: 2,
        ),
        leading: FaIcon(
          icon,
          color: iconColor,
          size: 18,
        ),
        title: Text(
          title,
          style: getMediumStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
            color: iconColor,
          ),
        ),

        trailing: trailing,
      ),
    );
  }



  void _showLanguageBottomSheet(BuildContext ctx, ColorScheme color ,AppLocalizations l10n ) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: Spacing.sm),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: color.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: Spacing.base),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
              child: Text(
                l10n.select_language,
                style: getBoldStyle(
                  fontSize: FontSize.size18,
                  fontFamily: FontConstant.cairo,
                  color: color.onSurface,
                ),
              ),
            ),
            const SizedBox(height: Spacing.base),
            _buildLanguageOption(
              context: context,
              title: 'العربية',
              subtitle: 'Arabic',
              isSelected: true,
              onTap: () {
                Navigator.pop(context);
                // TODO: Change language to Arabic
              },
              color: color,
            ),
            const Divider(height: 1),
            _buildLanguageOption(
              context: context,
              title: 'English',
              subtitle: 'الإنجليزية',
              isSelected: false,
              onTap: () {
                Navigator.pop(context);
                // TODO: Change language to English
              },
              color: color,
            ),
            const SizedBox(height: Spacing.base),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme color,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Spacing.base,
        vertical: Spacing.xs,
      ),
      leading: Container(
        padding: const EdgeInsets.all(Spacing.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? color.primaryContainer
              : color.background,
          borderRadius: BorderRadius.circular(Spacing.sm),
        ),
        child: FaIcon(
          FontAwesomeIcons.globe,
          color: isSelected ? color.primary : color.onSurfaceVariant,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: getBoldStyle(
          fontSize: FontSize.size16,
          fontFamily: FontConstant.cairo,
          color: isSelected ? color.primary : color.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: getMediumStyle(
          fontSize: FontSize.size13,
          fontFamily: FontConstant.cairo,
          color: color.onSurfaceVariant,
        ),
      ),
      trailing: isSelected
          ? FaIcon(
              FontAwesomeIcons.circleCheck,
              color: color.primary,
              size: 20,
            )
          : null,
    );
  }
}
