import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/core/services/cart_count_sync_service.dart';
import 'package:zadana_user_v3/core/services/cart_navigation_service.dart';
import 'package:zadana_user_v3/core/services/category_navigation_service.dart';
import 'package:zadana_user_v3/core/services/device_id_service.dart';
import 'package:zadana_user_v3/core/services/favorite_sync_service.dart';
import 'package:zadana_user_v3/core/services/favorites_navigation_service.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/core/widgets/app_drawer.dart';
import 'package:zadana_user_v3/feature/app_section/manager/nav_badge_cubit.dart';
import 'package:zadana_user_v3/feature/app_section/manager/nav_badge_state.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/get_cart_usecase.dart';
import 'package:zadana_user_v3/feature/cart/presentation/pages/cart_screen.dart';
import 'package:zadana_user_v3/feature/category/presentation/pages/category_screen.dart';
import 'package:zadana_user_v3/feature/favorites/data/data_source/favorites_remote_data_source_impl.dart';
import 'package:zadana_user_v3/feature/favorites/data/repo/favorites_repository.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/pages/favorites_screen.dart';
import 'package:zadana_user_v3/feature/home/presentation/pages/home_screen.dart';
import 'package:zadana_user_v3/feature/profile/presentation/pages/profile_screen.dart';

final GlobalKey<MainShellState> mainShellKey = GlobalKey<MainShellState>();
const double kMainShellBottomNavHeight = 75.0;
const double kMainShellBottomNavBottomOffset = 12.0;
const double kMainShellBottomNavTopMargin = 5.0;

double mainShellBottomNavReservedSpace(BuildContext context) {
  final safeBottomInset = MediaQuery.paddingOf(context).bottom;
  return kMainShellBottomNavHeight +
      safeBottomInset +
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
  late final List<Widget?> _loadedScreens;
  late final NavBadgeCubit _navBadgeCubit;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _loadedScreens = List<Widget?>.filled(5, null);
    _navBadgeCubit = NavBadgeCubit(
      getIt<GetCartUseCase>(),
      FavoritesRepository(
        FavoritesRemoteDataSourceImpl(
          getIt<ApiServices>(),
          getIt<Dio>(),
          getIt<TokenService>(),
          getIt<DeviceIdService>(),
        ),
      ),
      FavoriteSyncService(),
      CartCountSyncService(),
    )..loadCounts();
    _ensureScreenLoaded(_selectedIndex);
  }

  @override
  void dispose() {
    _navBadgeCubit.close();
    super.dispose();
  }

  List<NavBarItem> _buildNavItems(BuildContext context) {
    final locale = context.localization;
    return [
      NavBarItem(
        icon: Iconsax.home,
        activeIcon: Iconsax.home_15,
        title: locale.nav_home,
      ),
      NavBarItem(
        icon: Iconsax.shopping_bag,
        activeIcon: Iconsax.shopping_bag5,
        title: locale.shopping,
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
    ];
  }

  void _onItemTapped(int index) {
    final wasScreenLoaded = _loadedScreens[index] != null;

    if (index == 1) {
      final isExternalCategorySelection = CategoryNavigationService()
          .consumePendingExternalSelection();
      if (!isExternalCategorySelection) {
        CategoryNavigationService().notifyTabChanged();
      }
    }
    if (index == 3 && _selectedIndex != 3) {
      FavoritesNavigationService().notifyTabChanged();
    }

    if (_selectedIndex != index) {
      setState(() {
        _ensureScreenLoaded(index);
        _selectedIndex = index;
      });
      if (index == 2 && wasScreenLoaded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          CartNavigationService().notifyTabChanged();
        });
      }
      return;
    }

    _ensureScreenLoaded(index);
    if (index == 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        CartNavigationService().notifyTabChanged();
      });
    }
  }

  void jumpToTab(int index) {
    _onItemTapped(index);
  }

  void openDrawer() => _scaffoldKey.currentState?.openDrawer();

  void _ensureScreenLoaded(int index) {
    _loadedScreens[index] ??= switch (index) {
      0 => HomeScreen(onMenuTap: openDrawer),
      1 => const CategoryScreen(),
      2 => const CartScreen(),
      3 => const FavoritesScreen(),
      4 => const ProfileScreen(),
      _ => const SizedBox.shrink(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafeInset = MediaQuery.paddingOf(context).bottom;
    final navItems = _buildNavItems(context);

    return BlocProvider.value(
      value: _navBadgeCubit,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const AppDrawer(),
        drawerEdgeDragWidth: 20,
        body: Stack(
          children: [
            ...List.generate(_loadedScreens.length, (index) {
              final screen = _loadedScreens[index];
              if (screen == null) {
                return const SizedBox.shrink();
              }

              return Offstage(
                offstage: _selectedIndex != index,
                child: HeroMode(
                  enabled: _selectedIndex == index,
                  child: screen,
                ),
              );
            }),
            Positioned(
              bottom: bottomSafeInset + kMainShellBottomNavBottomOffset,
              left: 12,
              right: 12,
              child: BlocBuilder<NavBadgeCubit, NavBadgeState>(
                builder: (context, state) {
                  return CustomBottomNavBar(
                    selectedIndex: _selectedIndex,
                    navItems: navItems,
                    cartCount: state.cartCount,
                    favoritesCount: state.favoritesCount,
                    onItemSelected: _onItemTapped,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavBarItem {
  NavBarItem({
    required this.icon,
    required this.title,
    required this.activeIcon,
  });

  final IconData icon;
  final String title;
  final IconData activeIcon;
}

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.navItems,
    required this.cartCount,
    required this.favoritesCount,
    required this.onItemSelected,
  });

  final int selectedIndex;
  final List<NavBarItem> navItems;
  final int cartCount;
  final int favoritesCount;
  final Function(int) onItemSelected;

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final navBackground = Color.alphaBlend(
      color.surfaceTint.withValues(alpha: 0.03),
      color.surfaceContainerLow,
    );

    return Container(
      height: kMainShellBottomNavHeight,
      margin: const EdgeInsets.only(top: kMainShellBottomNavTopMargin),
      decoration: BoxDecoration(
        color: navBackground,
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(children: [..._buildItems(context, 0, 5)]),
    );
  }

  List<Widget> _buildItems(BuildContext context, int from, int to) {
    final color = context.colorScheme;
    final activeBackground = Color.alphaBlend(
      color.primary.withValues(alpha: 0.14),
      color.surface,
    );
    final inactiveBackground = color.surface.withValues(alpha: 0.72);

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
                        color: active
                            ? activeBackground
                            : inactiveBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              active ? item.activeIcon : item.icon,
                              key: ValueKey(
                                active ? item.activeIcon : item.icon,
                              ),
                              size: 24,
                              color: active
                                  ? color.primary
                                  : color.onSurfaceVariant,
                            ),
                          ),
                          if (_badgeCountFor(index) > 0)
                            Positioned(
                              top: -8,
                              right: -8,
                              child: _NavBadge(count: _badgeCountFor(index)),
                            ),
                        ],
                      ),
                    ),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: getSemiBoldStyle(
                        fontSize: 10,
                        fontFamily: FontConstant.cairo,
                        color: active
                            ? color.primary
                            : color.onSurfaceVariant.withValues(alpha: 0.9),
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

  int _badgeCountFor(int index) {
    if (index == 2) return widget.cartCount;
    if (index == 3) return widget.favoritesCount;
    return 0;
  }
}

class _NavBadge extends StatelessWidget {
  const _NavBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final displayCount = count > 99 ? '99+' : '$count';

    return Container(
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.error,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.surfaceContainerLowest, width: 1.5),
      ),
      child: Center(
        child: Text(
          displayCount,
          textAlign: TextAlign.center,
          style: getBoldStyle(
            fontSize: 9,
            fontFamily: FontConstant.cairo,
            color: color.onError,
          ),
        ),
      ),
    );
  }
}
