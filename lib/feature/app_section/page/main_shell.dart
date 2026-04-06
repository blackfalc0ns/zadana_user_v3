import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/services/cart_navigation_service.dart';
import 'package:zadana_user_v3/core/services/category_navigation_service.dart';
import 'package:zadana_user_v3/core/services/favorites_navigation_service.dart';
import 'package:zadana_user_v3/core/widgets/app_drawer.dart';
import 'package:zadana_user_v3/feature/cart/presentation/pages/cart_screen.dart';
import 'package:zadana_user_v3/feature/category/presentation/pages/category_screen.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/pages/favorites_screen.dart';
import 'package:zadana_user_v3/feature/home/presentation/pages/home_screen.dart';
import 'package:zadana_user_v3/feature/profile/presentation/pages/profile_screen.dart';

final GlobalKey<MainShellState> mainShellKey = GlobalKey<MainShellState>();
const double kMainShellBottomNavHeight = 75.0;
const double kMainShellBottomNavBottomOffset = 12.0;
const double kMainShellBottomNavTopMargin = 5.0;

double mainShellBottomNavReservedSpace(BuildContext context) {
  return kMainShellBottomNavHeight +
      kMainShellBottomNavBottomOffset +
      kMainShellBottomNavTopMargin;
}

class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell> {
  late int _selectedIndex;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<NavBarItem> _navItems = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initializeNavItems();
      _isInitialized = true;
    }
  }

  void _initializeNavItems() {
    final locale = context.localization;
    _navItems.addAll([
      NavBarItem(
        icon: Iconsax.home,
        activeIcon: Iconsax.home_15,
        title: locale.nav_home,
      ),
      NavBarItem(
        icon: Iconsax.shopping_bag,
        activeIcon: Iconsax.shopping_bag5,
        title: 'تسوق',
      ),
      NavBarItem(
        icon: Iconsax.shopping_cart,
        activeIcon: Iconsax.shopping_cart5,
        title: locale.nav_cart,
      ),
      NavBarItem(
        icon: Iconsax.heart,
        activeIcon: Iconsax.heart5,
        title: locale.favorites,
      ),
      NavBarItem(
        icon: Iconsax.profile_circle,
        activeIcon: Iconsax.profile_circle5,
        title: locale.nav_profile,
      ),
    ]);
  }

  void _onItemTapped(int index) {
    if (index == 1 && _selectedIndex != 1) {
      CategoryNavigationService().notifyTabChanged();
    }
    if (index == 2 && _selectedIndex != 2) {
      CartNavigationService().notifyTabChanged();
    }
    if (index == 3 && _selectedIndex != 3) {
      FavoritesNavigationService().notifyTabChanged();
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  void jumpToTab(int index) {
    _onItemTapped(index);
  }

  void openDrawer() => _scaffoldKey.currentState?.openDrawer();

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onMenuTap: openDrawer),
      const CategoryScreen(),
      const CartScreen(),
      const FavoritesScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      drawerEdgeDragWidth: 20,
      body: Stack(
        children: [
          ...List.generate(
            screens.length,
            (index) => Offstage(
              offstage: _selectedIndex != index,
              child: HeroMode(
                enabled: _selectedIndex == index,
                child: screens[index],
              ),
            ),
          ),
          Positioned(
            bottom: kMainShellBottomNavBottomOffset,
            left: 12,
            right: 12,
            child: CustomBottomNavBar(
              selectedIndex: _selectedIndex,
              navItems: _navItems,
              onItemSelected: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}

class NavBarItem {
  final IconData icon;
  final String title;
  final IconData activeIcon;

  NavBarItem({
    required this.icon,
    required this.title,
    required this.activeIcon,
  });
}

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final List<NavBarItem> navItems;
  final Function(int) onItemSelected;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.navItems,
    required this.onItemSelected,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kMainShellBottomNavHeight,
      margin: const EdgeInsets.only(top: kMainShellBottomNavTopMargin),
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(children: [..._buildItems(context, 0, 5)]),
    );
  }

  List<Widget> _buildItems(BuildContext context, int from, int to) {
    return List.generate(to - from, (i) {
      final index = from + i;
      final item = widget.navItems[index];
      final active = widget.selectedIndex == index;

      return Expanded(
        child: GestureDetector(
          onTap: () => widget.onItemSelected(index),
          behavior: HitTestBehavior.opaque,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 1.0, end: active ? 1.1 : 1.0),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          active ? item.activeIcon : item.icon,
                          key: ValueKey(active ? item.activeIcon : item.icon),
                          size: 24,
                          color: active
                              ? AppColors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: getSemiBoldStyle(
                        fontSize: 10,
                        fontFamily: FontConstant.cairo,
                        color: active
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      child: Text(item.title),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
