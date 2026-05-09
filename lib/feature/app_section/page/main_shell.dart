import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/general_cubit/general_state.dart';
import 'package:zadana_user_v3/core/general_cubit/local_cubit.dart';
import 'package:zadana_user_v3/core/services/cart_navigation_service.dart';
import 'package:zadana_user_v3/core/services/category_navigation_service.dart';
import 'package:zadana_user_v3/core/widgets/app_drawer.dart';
import 'package:zadana_user_v3/feature/app_section/manager/app_section_global_cubit.dart';
import 'package:zadana_user_v3/feature/app_section/manager/app_section_global_state.dart';
import 'package:zadana_user_v3/feature/cart/presentation/manager/cart_event.dart';
import 'package:zadana_user_v3/feature/cart/presentation/pages/cart_screen.dart';
import 'package:zadana_user_v3/feature/category/presentation/pages/category_screen.dart';
import 'package:zadana_user_v3/feature/favorites/data/repo/favorites_repository.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/pages/favorites_screen.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_event.dart';
import 'package:zadana_user_v3/feature/home/presentation/pages/home_screen.dart';
import 'package:zadana_user_v3/feature/profile/presentation/pages/profile_screen.dart';

GlobalKey<MainShellState> mainShellKey = GlobalKey<MainShellState>();
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
  late final List<bool> _requestedInitialData;
  late final AppSectionGlobalCubit _globalCubit;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _loadedScreens = List<Widget?>.filled(5, null);
    _requestedInitialData = List<bool>.filled(5, false);
    final getItInstance = getIt;
    getItInstance<FavoritesRepository>();
    _globalCubit = getItInstance<AppSectionGlobalCubit>()..initialize();
    _ensureScreenLoaded(_selectedIndex);
  }

  @override
  void dispose() {
    _globalCubit.close();
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
    if (index == 1) {
      CategoryNavigationService().consumePendingExternalSelection();
    }

    if (index == 2) {
      CartNavigationService().notifyTabChanged(reload: false);
    }

    if (_selectedIndex != index) {
      setState(() {
        _ensureScreenLoaded(index);
        _selectedIndex = index;
      });
      return;
    }

    _ensureScreenLoaded(index);
  }

  void jumpToTab(int index) {
    _onItemTapped(index);
  }

  void openDrawer() => _scaffoldKey.currentState?.openDrawer();

  void _ensureScreenLoaded(int index) {
    final isFirstLoad = _loadedScreens[index] == null;

    _loadedScreens[index] ??= switch (index) {
      0 => HomeScreen(onMenuTap: openDrawer),
      1 => const CategoryScreen(),
      2 => const CartScreen(),
      3 => const FavoritesScreen(),
      4 => const ProfileScreen(),
      _ => const SizedBox.shrink(),
    };

    if (isFirstLoad) {
      _ensureTabDataLoaded(index);
    }
  }

  void _ensureTabDataLoaded(int index) {
    if (_requestedInitialData[index]) return;
    _requestedInitialData[index] = true;

    switch (index) {
      case 0:
        _globalCubit.homeViewModel.doIntent(const HomeLoadEvent());
        break;
      case 1:
        _globalCubit.categoryViewModel.initialize();
        break;
      case 2:
        final loadedVendorId = _globalCubit.cartViewModel.state.loadedVendorId;
        _globalCubit.cartViewModel
          ..doIntent(const CartLoadVendorsEvent())
          ..doIntent(CartLoadItemsEvent(vendorId: loadedVendorId));
        break;
      case 3:
        _globalCubit.favoritesViewModel.loadFavorites();
        break;
      case 4:
        _globalCubit.refreshProfileAuthState();
        break;
    }
  }

  void _refreshLocalizedContent() {
    _globalCubit.homeViewModel.doIntent(const HomeRetryEvent());
    _globalCubit.categoryViewModel.loadInitialData();

    final loadedVendorId = _globalCubit.cartViewModel.state.loadedVendorId;
    _globalCubit.cartViewModel
      ..doIntent(const CartLoadVendorsEvent())
      ..doIntent(CartLoadItemsEvent(vendorId: loadedVendorId));

    _globalCubit.favoritesViewModel.loadFavorites(silent: true);
  }

  Widget _buildScreenForIndex(int index) {
    final screen = _loadedScreens[index];
    if (screen == null) {
      return const SizedBox.shrink();
    }

    return Offstage(
      offstage: _selectedIndex != index,
      child: HeroMode(enabled: _selectedIndex == index, child: screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafeInset = MediaQuery.paddingOf(context).bottom;
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final isKeyboardVisible = keyboardInset > 0;
    final navItems = _buildNavItems(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _globalCubit),
        BlocProvider.value(value: _globalCubit.homeViewModel),
        BlocProvider.value(value: _globalCubit.cartViewModel),
        BlocProvider.value(value: _globalCubit.favoritesViewModel),
        BlocProvider.value(value: _globalCubit.profileViewModel),
        BlocProvider.value(value: _globalCubit.categoryViewModel),
      ],
      child: BlocListener<LocaleThemeCubit, LocaleThemeState>(
        listenWhen: (previous, current) =>
            previous.locale.languageCode != current.locale.languageCode,
        listener: (context, state) => _refreshLocalizedContent(),
        child: Scaffold(
          key: _scaffoldKey,
          drawer: const AppDrawer(),
          drawerEdgeDragWidth: 20,
          body: Stack(
            children: [
              ...List.generate(_loadedScreens.length, _buildScreenForIndex),
              if (!isKeyboardVisible)
                Positioned(
                  bottom: bottomSafeInset + kMainShellBottomNavBottomOffset,
                  left: 12,
                  right: 12,
                  child:
                      BlocBuilder<AppSectionGlobalCubit, AppSectionGlobalState>(
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
            offset: const Offset(0, -2),
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
                        color: active ? activeBackground : inactiveBackground,
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
