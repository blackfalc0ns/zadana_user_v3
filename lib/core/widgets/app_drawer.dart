import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/drawer/drawer_header.dart'
    as custom_header;
import 'package:zadana_user_v3/core/widgets/drawer/drawer_menu_item.dart';
import 'package:zadana_user_v3/core/widgets/drawer/drawer_actions.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          // Header
          const custom_header.DrawerHeader(),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Personal Information Section
                _buildPersonalInfoSection(context, locale),
                const Divider(color: AppColors.divider),
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
    );
  }

  Widget _buildPersonalInfoSection(BuildContext context, dynamic locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'المعلومات الشخصية',
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.user,
          title: 'الاسم الكامل',
          subtitle: 'abdo mohamed',
          iconColor: AppColors.secondary,
          onTap: () {},
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.phone,
          title: 'رقم الهاتف',
          subtitle: '01028233582',
          iconColor: AppColors.info,
          onTap: () {},
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.envelope,
          title: 'البريد الإلكتروني',
          subtitle: 'baderahmed40@gmail.com',
          iconColor: AppColors.warning,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildMainMenuItems(BuildContext context, dynamic locale) {
    return Column(
      children: [
        DrawerMenuItem(
          icon: FontAwesomeIcons.bell,
          title: 'الإشعارات',
          iconColor: AppColors.secondary,
          onTap: () => DrawerActions.handleNotifications(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.heart,
          title: 'المفضلة',
          iconColor: AppColors.error,
          onTap: () => DrawerActions.handleFavorites(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.listUl,
          title: 'الأقسام',
          iconColor: AppColors.primary,
          onTap: () => DrawerActions.handleCategories(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.bagShopping,
          title: 'طلباتي',
          iconColor: AppColors.success,
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
          iconColor: AppColors.secondary,
          onTap: () => DrawerActions.handleLanguage(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.shield,
          title: 'السياسة والخصوصية',
          iconColor: AppColors.primary,
          onTap: () => DrawerActions.handlePrivacyPolicy(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.circleInfo,
          title: 'عن التطبيق',
          iconColor: AppColors.info,
          onTap: () => DrawerActions.handleAboutApp(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.code,
          title: 'المطور',
          iconColor: AppColors.success,
          onTap: () => DrawerActions.handleDeveloper(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.tag,
          title: 'الإصدار',
          subtitle: 'v1.0.0',
          iconColor: AppColors.secondary,
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
          iconColor: AppColors.success,
          onTap: () => DrawerActions.handleContactUs(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.headset,
          title: 'المساعدة والدعم',
          iconColor: AppColors.secondary,
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
      iconColor: AppColors.error,
      onTap: () => DrawerActions.handleLogout(context),
    );
  }
}
