import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/services/category_navigation_service.dart';
import 'package:zadana_user_v3/feature/category/presentation/pages/category_screen.dart';
import 'package:zadana_user_v3/feature/home/presentation/pages/home_screen.dart';
import 'package:zadana_user_v3/feature/profile/presentation/pages/profile_screen.dart';
import 'package:zadana_user_v3/feature/cart/presentation/pages/cart_screen.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/pages/favorites_screen.dart';

// Global key للوصول للـ controller من أي مكان
final GlobalKey<MainShellState> mainShellKey = GlobalKey<MainShellState>();

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    
    // إضافة listener للـ controller عشان نعرف لما يتم الانتقال للتاب
    _controller.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    // لما ننتقل لتاب التسوق (index 1)، نتحقق من القسم المختار
    if (_controller.index == 1) {
      // إعطاء وقت قصير للتاب للتحميل ثم إرسال إشعار
      Future.delayed(const Duration(milliseconds: 50), () {
        // إرسال إشعار للـ CategoryScreen للتحقق من القسم المختار
        CategoryNavigationService().notifyTabChanged();
      });
    }
  }

  // Method للانتقال لتاب معين
  void jumpToTab(int index) {
    _controller.jumpToTab(index);
  }

  List<PersistentTabConfig> _tabs(BuildContext context) {
    final locale = context.localization;
    
    return [
      PersistentTabConfig(
        screen: const HomeScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.home_rounded),
          title: locale.nav_home,
          activeForegroundColor: AppColors.primary,
          inactiveForegroundColor: AppColors.textSecondary,
        ),
      ),
      PersistentTabConfig(
        screen: const CategoryScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.shopping_bag_outlined),
          title: 'تسوق',
          activeForegroundColor: AppColors.primary,
          inactiveForegroundColor: AppColors.textSecondary,
        ),
      ),
      PersistentTabConfig(
        screen: const FavoritesScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.favorite_outline_rounded),
          title: locale.nav_orders,
          activeForegroundColor: AppColors.primary,
          inactiveForegroundColor: AppColors.textSecondary,
        ),
      ),
      PersistentTabConfig(
        screen: const ProfileScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.person_outline_rounded),
          title: locale.nav_profile,
          activeForegroundColor: AppColors.primary,
          inactiveForegroundColor: AppColors.textSecondary,
        ),
      ),
      PersistentTabConfig(
        screen: const CartScreen(),
        item: ItemConfig(
          icon: const FaIcon(FontAwesomeIcons.cartPlus),
          title: 'العربة',
          activeForegroundColor: AppColors.primary,
          inactiveForegroundColor: AppColors.textSecondary,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      tabs: _tabs(context),
      navBarBuilder: (navBarConfig) => CustomBottomNavBar(
        navBarConfig: navBarConfig,
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final NavBarConfig navBarConfig;

  const CustomBottomNavBar({
    super.key,
    required this.navBarConfig,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Bar background ────────────────────────────────────
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 12,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Left 2 items
                  ..._buildItems(context, 0, 2),
                  // Center placeholder for cart
                  const Expanded(child: SizedBox()),
                  // Right 2 items
                  ..._buildItems(context, 2, 4),
                ],
              ),
            ),
          ),

          // ── Floating cart button ──────────────────────────────
          Positioned(
            top: -18,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => navBarConfig.onItemSelected(4), // Cart is index 4
                child: Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: navBarConfig.selectedIndex == 4 
                        ? AppColors.primary 
                        : AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.40),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.cartPlus,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildItems(BuildContext context, int from, int to) {
    return List.generate(to - from, (i) {
      final index = from + i;
      final item = navBarConfig.items[index];
      final active = navBarConfig.selectedIndex == index;

      return Expanded(
        child: GestureDetector(
          onTap: () => navBarConfig.onItemSelected(index),
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                (item.icon as Icon).icon,
                size: 22,
                color: active ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(height: 3),
              Text(
                item.title ?? '',
                style: TextStyle(
                  fontSize: 10,
                  color: active ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}