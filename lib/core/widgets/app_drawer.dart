import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/drawer/drawer_header.dart'
    as custom_header;
import 'package:zadana_user_v3/core/widgets/drawer/drawer_menu_item.dart';
import 'package:zadana_user_v3/core/widgets/drawer/drawer_actions.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Drawer(
        backgroundColor: color.surface,
        child: Column(
          children: [
            const custom_header.DrawerHeader(),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      _buildPersonalInfoSection(context),
                      Divider(color: color.onSurface.withValues(alpha: 0.12)),
                      _buildMainMenuItems(context),
                      Divider(color: color.onSurface.withValues(alpha: 0.12)),
                      _buildSettingsMenuItems(context),
                      Divider(color: color.onSurface.withValues(alpha: 0.12)),
                      _buildSupportMenuItems(context),
                      Divider(color: color.onSurface.withValues(alpha: 0.12)),
                      _buildLogoutMenuItem(context),
                      const SizedBox(height: 20),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DrawerMenuItem(
          icon: FontAwesomeIcons.user,
          title: locale.name,
          subtitle: 'abdo mohamed',
          iconColor: color.primary,
          onTap: () {},
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.phone,
          title: locale.phone,
          subtitle: '01028233582',
          iconColor: color.secondary,
          onTap: () {},
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.envelope,
          title: locale.label_email,
          subtitle: 'baderahmed40@gmail.com',
          iconColor: color.primary,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildMainMenuItems(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;
    return Column(
      children: [
        DrawerMenuItem(
          icon: FontAwesomeIcons.bell,
          title: locale.notifications,
          iconColor: color.secondary,
          onTap: () => DrawerActions.handleNotifications(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.heart,
          title: locale.nav_orders,
          iconColor: color.primary,
          onTap: () => DrawerActions.handleFavorites(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.listUl,
          title: locale.nav_categories,
          iconColor: color.secondary,
          onTap: () => DrawerActions.handleCategories(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.bagShopping,
          title: locale.nav_cart,
          iconColor: color.primary,
          onTap: () => DrawerActions.handleMyOrders(context),
        ),
      ],
    );
  }

  Widget _buildSettingsMenuItems(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;
    return Column(
      children: [
        DrawerMenuItem(
          icon: FontAwesomeIcons.globe,
          title: locale.language,
          iconColor: color.secondary,
          onTap: () => DrawerActions.handleLanguage(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.shield,
          title: locale.privacy_policy,
          iconColor: color.primary,
          onTap: () => DrawerActions.handlePrivacyPolicy(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.circleInfo,
          title: locale.about_app,
          iconColor: color.secondary,
          onTap: () => DrawerActions.handleAboutApp(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.code,
          title: locale.developer,
          iconColor: color.primary,
          onTap: () => DrawerActions.handleDeveloper(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.tag,
          title: locale.version,
          subtitle: 'v1.0.0',
          iconColor: color.secondary,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSupportMenuItems(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;
    return Column(
      children: [
        DrawerMenuItem(
          icon: FontAwesomeIcons.phone,
          title: locale.contact_us,
          iconColor: color.primary,
          onTap: () => DrawerActions.handleContactUs(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.headset,
          title: locale.help_support,
          iconColor: color.secondary,
          onTap: () => DrawerActions.handleSupport(context),
        ),
      ],
    );
  }

  Widget _buildLogoutMenuItem(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;
    return DrawerMenuItem(
      icon: FontAwesomeIcons.rightFromBracket,
      title: locale.logout,
      textColor: color.error,
      iconColor: color.error,
      onTap: () => DrawerActions.handleLogout(context),
    );
  }
}
