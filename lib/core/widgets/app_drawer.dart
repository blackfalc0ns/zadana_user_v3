import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/drawer/drawer_actions.dart';
import 'package:zadana_user_v3/core/widgets/drawer/drawer_footer.dart';
import 'package:zadana_user_v3/core/widgets/drawer/drawer_header.dart'
    as custom_header;
import 'package:zadana_user_v3/core/widgets/drawer/drawer_menu_item.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.68,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.base,
                        ),
                        child: Divider(
                          color: color.onSurface.withValues(alpha: 0.12),
                        ),
                      ),
                      _buildMainMenuItems(context),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.base,
                        ),
                        child: Divider(
                          color: color.onSurface.withValues(alpha: 0.12),
                        ),
                      ),
                      _buildSettingsMenuItems(context),
                    ]),
                  ),
                ],
              ),
            ),
            const DrawerFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection(BuildContext context) {
    final locale = context.localization;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DrawerMenuItem(
          icon: FontAwesomeIcons.user,
          title: locale.nav_profile,
          subtitle: isArabic
              ? 'الاسم، رقم الجوال، البريد الإلكتروني'
              : 'Name, phone, and email',
          onTap: () => DrawerActions.handleProfile(context),
        ),
      ],
    );
  }

  Widget _buildMainMenuItems(BuildContext context) {
    final locale = context.localization;
    return Column(
      children: [
        DrawerMenuItem(
          icon: FontAwesomeIcons.bell,
          title: locale.notifications,
          onTap: () => DrawerActions.handleNotifications(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.heart,
          title: locale.favorites,
          onTap: () => DrawerActions.handleFavorites(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.listUl,
          title: locale.shopping,
          onTap: () => DrawerActions.handleCategories(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.cartPlus,
          title: locale.nav_cart,
          onTap: () => DrawerActions.handleCart(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.bagShopping,
          title: locale.nav_orders,
          onTap: () => DrawerActions.handleMyOrders(context),
        ),
      ],
    );
  }

  Widget _buildSettingsMenuItems(BuildContext context) {
    final locale = context.localization;
    return Column(
      children: [
        DrawerMenuItem(
          icon: FontAwesomeIcons.globe,
          title: locale.language,
          onTap: () => DrawerActions.handleLanguage(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.circleQuestion,
          title: locale.faq,
          onTap: () => DrawerActions.handleFaq(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.shieldHalved,
          title: locale.privacy_policy,
          onTap: () => DrawerActions.handlePrivacyPolicy(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.fileContract,
          title: locale.terms_conditions,
          onTap: () => DrawerActions.handleTermsConditions(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.shield,
          title: locale.help_support,
          onTap: () => DrawerActions.handleSupport(context),
        ),
        DrawerMenuItem(
          icon: FontAwesomeIcons.circleInfo,
          title: locale.about_app,
          onTap: () => DrawerActions.handleAboutApp(context),
        ),
      ],
    );
  }
}
