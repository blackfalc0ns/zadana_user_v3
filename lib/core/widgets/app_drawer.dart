import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/constants/app_constants.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/utils/assets.dart';
import 'package:zadana_user_v3/core/widgets/drawer/drawer_menu_item.dart';
import 'package:zadana_user_v3/core/widgets/drawer/drawer_actions.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final color = context.colorScheme;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.65, // 75% من عرض الشاشة
      child: Drawer(
        backgroundColor: color.surface,
        child: Column(
          children: [
            // Menu Items
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      _buildHeader(context),
                      // Personal Information Section
                      _buildPersonalInfoSection(context, locale, color),
                      Divider(
                        color: color.outlineVariant.withValues(alpha: 0.1),
                        height: 0.01,
                      ),
                      _buildMainMenuItems(context, locale, color),
                      Divider(
                        color: color.outlineVariant.withValues(alpha: 0.1),
                        height: 0.01,
                      ),

                      _buildSettingsMenuItems(context, locale, color),
                      Divider(
                        color: color.outlineVariant.withValues(alpha: 0.1),
                        height: 0.01,
                      ),

                      _buildSupportMenuItems(context, locale, color),
                      Divider(
                        color: color.outlineVariant.withValues(alpha: 0.1),
                        height: 0.01,
                      ),

                      _buildLogoutMenuItem(context, locale, color),
                      const SizedBox(height: 20),
                      _buildDeveloperInfo(context),
                      const SizedBox(height: 120), // مساحة من تحت
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

  Widget _buildHeader(BuildContext context) {
    final color = context.colorScheme;
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      decoration: BoxDecoration(
        color: color.primary,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // User Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.onPrimary,
              shape: BoxShape.circle,
            ),
            child: Icon(Iconsax.user, color: color.primary, size: 32),
          ),

          const SizedBox(height: 10),
          // User Details
          Text(
            'محمد أحمد',
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size16,
              color: color.onPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'mohamed@example.com',
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size12,
              color: color.onPrimary.withValues(alpha: 0.8),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(
    BuildContext context,
    AppLocalizations locale,
    ColorScheme color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DrawerMenuItem(
          icon: Iconsax.user,
          title: 'الاسم',
          subtitle: 'abdo mohamed',
          iconColor: color.primary,
          onTap: () {},
        ),
        DrawerMenuItem(
          icon: Iconsax.call,
          title: 'رقم الهاتف',
          subtitle: '01028233582',
          iconColor: color.primary,
          onTap: () {},
        ),
        DrawerMenuItem(
          icon: Iconsax.sms,
          title: 'البريد الإلكتروني',
          subtitle: 'baderahmed40@gmail.com',
          iconColor: color.primary,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildMainMenuItems(
    BuildContext context,
    AppLocalizations locale,
    ColorScheme color,
  ) {
    return Column(
      children: [
        DrawerMenuItem(
          icon: Iconsax.notification,
          title: 'الإشعارات',
          iconColor: color.primary,
          onTap: () => DrawerActions.handleNotifications(context),
        ),
        DrawerMenuItem(
          icon: Iconsax.heart,
          title: 'المفضلة',
          iconColor: color.primary,
          onTap: () => DrawerActions.handleFavorites(context),
        ),
        DrawerMenuItem(
          icon: Iconsax.category,
          title: 'الأقسام',
          iconColor: color.primary,
          onTap: () => DrawerActions.handleCategories(context),
        ),
        DrawerMenuItem(
          icon: Iconsax.shopping_bag,
          title: 'طلباتي',
          iconColor: color.primary,
          onTap: () => DrawerActions.handleMyOrders(context),
        ),
      ],
    );
  }

  Widget _buildSettingsMenuItems(
    BuildContext context,
    AppLocalizations locale,
    ColorScheme color,
  ) {
    return Column(
      children: [
        DrawerMenuItem(
          icon: Iconsax.global,
          title: 'اللغة',
          iconColor: color.primary,
          onTap: () => DrawerActions.handleLanguage(context),
        ),
        DrawerMenuItem(
          icon: Iconsax.shield,
          title: 'السياسة والخصوصية',
          iconColor: color.primary,
          onTap: () => DrawerActions.handlePrivacyPolicy(context),
        ),
        DrawerMenuItem(
          icon: Iconsax.info_circle,
          title: 'عن التطبيق',
          iconColor: color.primary,
          onTap: () => DrawerActions.handleAboutApp(context),
        ),
        DrawerMenuItem(
          icon: Iconsax.code,
          title: 'المطور',
          iconColor: color.primary,
          onTap: () => DrawerActions.handleDeveloper(context),
        ),
      ],
    );
  }

  Widget _buildSupportMenuItems(
    BuildContext context,
    AppLocalizations locale,
    ColorScheme color,
  ) {
    return Column(
      children: [
        DrawerMenuItem(
          icon: Iconsax.call,
          title: 'التواصل معنا',
          iconColor: color.primary,
          onTap: () => DrawerActions.handleContactUs(context),
        ),
        DrawerMenuItem(
          icon: Iconsax.headphone,
          title: 'المساعدة والدعم',
          iconColor: color.primary,
          onTap: () => DrawerActions.handleSupport(context),
        ),
      ],
    );
  }

  Widget _buildLogoutMenuItem(
    BuildContext context,
    AppLocalizations locale,
    ColorScheme color,
  ) {
    return DrawerMenuItem(
      icon: Iconsax.logout,
      title: 'تسجيل الخروج',
      textColor: color.error,
      iconColor: color.error,
      onTap: () => DrawerActions.handleLogout(context),
    );
  }

  Widget _buildDeveloperInfo(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDeveloperDialog(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // App Name and Developer Credit
            _buildDeveloperCredit(context),

            // Company Logo
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(AppAssets.blackFalconsIcon),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeveloperDialog(BuildContext context) {
    final color = context.colorScheme;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Stack(
            clipBehavior: Clip.none,
            children: [
              // Close Button
              Positioned(
                top: -8,
                right: -8,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Iconsax.close_circle,
                      size: 24,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              // Dialog Content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Developer Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage(AppAssets.blackFalconsIcon),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Developer Name
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Black ',
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size14,
                            color: color.onSurface,
                          ),
                        ),
                        TextSpan(
                          text: 'Falcons',
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size14,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Developer Description
                  Text(
                    'Black Falcons for digital solutions',
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size10,
                      color: color.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  // Contact Info
                  _buildContactButton(
                    icon: Iconsax.call,
                    title: 'اتصل بنا',
                    subtitle: '000000000',
                    onTap: () => _launchWhatsApp('000000000'),
                    color: color.onSurface,
                  ),

                  const SizedBox(height: 12),

                  _buildContactButton(
                    icon: Iconsax.sms,
                    title: 'البريد الإلكتروني',
                    subtitle: 'example@gmail.com',
                    onTap: () => _launchEmail('example@gmail.com'),
                    color: color.onSurface,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getSemiBoldStyle(
                    fontSize: FontSize.size10,
                    fontFamily: FontConstant.cairo,
                    color: color,
                  ),
                ),
                Text(
                  subtitle,
                  style: getSemiBoldStyle(
                    fontSize: FontSize.size10,
                    fontFamily: FontConstant.cairo,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchWhatsApp(String phone) async {
    final url = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchEmail(String email) async {
    final url = Uri.parse('mailto:$email');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Widget _buildDeveloperCredit(BuildContext context) {
    final color = context.colorScheme;
    return Column(
      children: [
        Text(
          AppConstants.appName,
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size13,
            color: color.onSurface,
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Developed by Black Falcons ',
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size10,
                  color: color.onSurface,
                ),
              ),
              TextSpan(
                text: 'v.1.0',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size10,
                  color: color.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
