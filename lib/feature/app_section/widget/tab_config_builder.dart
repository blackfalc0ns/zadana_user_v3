import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/cart/presentation/pages/cart_screen.dart';
import 'package:zadana_user_v3/feature/category/presentation/pages/category_screen.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/pages/favorites_screen.dart';
import 'package:zadana_user_v3/feature/home/presentation/pages/home_screen.dart';
import 'package:zadana_user_v3/feature/profile/presentation/pages/profile_screen.dart';

class TabConfigBuilder {
  static List<PersistentTabConfig> buildTabs(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return [
      _buildTab(
        const HomeScreen(),
        const Icon(Icons.home_rounded),
        locale.nav_home,
        color,
      ),
      _buildTab(
        const CategoryScreen(),
        const Icon(Icons.shopping_bag_outlined),
        locale.nav_categories,
        color,
      ),
      _buildTab(
        const FavoritesScreen(),
        const Icon(Icons.favorite_outline_rounded),
        locale.nav_orders,
        color,
      ),
      _buildTab(
        const ProfileScreen(),
        const Icon(Icons.person_outline_rounded),
        locale.nav_profile,
        color,
      ),
      _buildTab(
        const CartScreen(),
        const Icon(FontAwesomeIcons.cartPlus),
        locale.nav_cart,
        color,
      ),
    ];
  }

  static PersistentTabConfig _buildTab(
    Widget screen,
    Icon icon,
    String title,
    ColorScheme color,
  ) {
    return PersistentTabConfig(
      screen: screen,
      item: ItemConfig(
        icon: icon,
        title: title,
        activeForegroundColor: color.primary,
        inactiveForegroundColor: color.onSurface.withValues(alpha: 0.6),
      ),
    );
  }
}
