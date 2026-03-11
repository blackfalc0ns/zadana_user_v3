import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/drawer/drawer_header.dart' as custom_header;
import 'package:zadana_user_v3/core/widgets/drawer/drawer_menu_item.dart';
import 'package:zadana_user_v3/core/widgets/drawer/drawer_actions.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            const custom_header.DrawerHeader(),
            const SizedBox(height: Spacing.md),
            
            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMainMenuItems(context, locale),
                  const Divider(color: AppColors.divider),
                  _buildSettingsMenuItems(context, locale),
                  const Divider(color: AppColors.divider),
                  _buildSupportMenuItems(context, locale),
                  const Divider(color: AppColors.divider),
                  _buildLogoutMenuItem(context, locale),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainMenuItems(BuildContext context, dynamic locale) {
    return Column(
      children: [
        DrawerMenuItem(
          icon: FontAwesomeIcons.bell,
          title: 'الإشعارات',
          onTap: () => DrawerActions.handleNotifications(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.heart,
          title: 'المفضلة',
          onTap: () => DrawerActions.handleFavorites(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.listUl,
          title: 'الأقسام',
          onTap: () => DrawerActions.handleCategories(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.bagShopping,
          title: 'طلباتي',
          onTap: () => DrawerActions.handleMyOrders(context),
        ),
      ],
    );
  }

  Widget _buildSettingsMenuItems(BuildContext context, dynamic locale) {
    return Column(
      children: [
        DrawerMenuItem(
          icon: FontAwesomeIcons.globe,
          title: 'اللغة',
          onTap: () => DrawerActions.handleLanguage(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.shield,
          title: 'السياسة والخصوصية',
          onTap: () => DrawerActions.handlePrivacyPolicy(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.circleInfo,
          title: 'عن التطبيق',
          onTap: () => DrawerActions.handleAboutApp(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.code,
          title: 'المطور',
          onTap: () => DrawerActions.handleDeveloper(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.tag,
          title: 'الإصدار',
          subtitle: 'v1.0.0',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSupportMenuItems(BuildContext context, dynamic locale) {
    return Column(
      children: [
        DrawerMenuItem(
          icon: FontAwesomeIcons.phone,
          title: 'التواصل معنا',
          onTap: () => DrawerActions.handleContactUs(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.headset,
          title: 'المساعدة والدعم',
          onTap: () => DrawerActions.handleSupport(context),
        ),
      ],
    );
  }

  Widget _buildLogoutMenuItem(BuildContext context, dynamic locale) {
    return DrawerMenuItem(
      icon: FontAwesomeIcons.rightFromBracket,
      title: 'تسجيل الخروج',
      textColor: AppColors.error,
      onTap: () => DrawerActions.handleLogout(context),
    );
  }
}