import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/core/widgets/drawer/drawer_actions.dart';
import 'package:zadana_user_v3/core/widgets/drawer/drawer_footer.dart';
import 'package:zadana_user_v3/core/widgets/drawer/drawer_header.dart'
    as custom_header;
import 'package:zadana_user_v3/core/widgets/drawer/drawer_menu_item.dart';
import 'package:zadana_user_v3/feature/profile/domain/entities/profile_response_entity.dart';
import 'package:zadana_user_v3/feature/profile/domain/usecase/profile_usecase.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Future<_DrawerViewData> _loadDrawerViewData() async {
    final token = await getIt<TokenService>().getToken();
    final isGuest = token == null || token.isEmpty;

    if (isGuest) {
      return const _DrawerViewData(isGuest: true);
    }

    final result = await getIt<ProfileUseCase>().call();
    if (result is ApiSuccessResult<ProfileResponseEntity>) {
      final profile = result.data;
      final secondary = profile.email.trim().isNotEmpty
          ? profile.email.trim()
          : profile.phone.trim();
      return _DrawerViewData(
        isGuest: false,
        displayName: profile.fullName.trim(),
        secondaryText: secondary,
      );
    }

    return const _DrawerViewData(isGuest: false);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.68,
      child: Drawer(
        backgroundColor: color.surface,
        child: FutureBuilder<_DrawerViewData>(
          future: _loadDrawerViewData(),
          builder: (context, snapshot) {
            final data = snapshot.data ?? const _DrawerViewData(isGuest: true);

            return Column(
              children: [
                custom_header.DrawerHeader(
                  isGuest: data.isGuest,
                  displayName: data.displayName,
                  secondaryText: data.secondaryText,
                ),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate([
                          const SizedBox(height: Spacing.sm),
                          _buildMainMenuItems(context, isGuest: data.isGuest),
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
                DrawerFooter(isGuest: data.isGuest),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainMenuItems(BuildContext context, {required bool isGuest}) {
    final locale = context.localization;
    final items = <Widget>[
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
    ];

    if (!isGuest) {
      items.add(
        DrawerMenuItem(
          icon: FontAwesomeIcons.bagShopping,
          title: locale.nav_orders,
          onTap: () => DrawerActions.handleMyOrders(context),
        ),
      );
    }

    return Column(children: items);
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

class _DrawerViewData {
  const _DrawerViewData({
    required this.isGuest,
    this.displayName,
    this.secondaryText,
  });

  final bool isGuest;
  final String? displayName;
  final String? secondaryText;
}
