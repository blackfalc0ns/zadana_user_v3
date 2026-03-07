// import 'package:flutter/material.dart';
// import 'package:zadana_user_v3/core/extensions/extensions.dart';
// import 'package:zadana_user_v3/feature/category/presentaion/pages/category_screen.dart';
// import 'package:zadana_user_v3/feature/home/presentation/pages/home_screen.dart';
// import 'package:zadana_user_v3/feature/app_section/widget/home_bottom_nav_bar.dart';

// class MainShell extends StatefulWidget {
//   const MainShell({super.key});

//   @override
//   State<MainShell> createState() => _MainShellState();
// }

// class _MainShellState extends State<MainShell> {
//   int _navIndex = 0;

//   static const List<Widget> _screens = [
    
//     HomeScreen(),
//     CategoryScreen(),
//     Center(child: Text('Order')),
//     Center(child: Text('Profile')),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final locale = context.localization;

//     return Scaffold(
//       // ── Body ──────────────────────────────────────────────────
//       body: _screens[_navIndex], // ← comma ضرورية هنا

//       // ── Bottom Nav ────────────────────────────────────────────
//       bottomNavigationBar: HomeBottomNavBar(
//         currentIndex: _navIndex,
//         onTap: (i) => setState(() => _navIndex = i),
//         onCartTap: () {},
//         items: [
//           HomeNavItem(
//             icon:  Icons.home_rounded,
//             label: locale.nav_home,
//           ),
//           HomeNavItem(
//             icon:  Icons.grid_view_rounded,
//             label: locale.nav_categories,
//           ),
//           HomeNavItem(
//             icon:  Icons.receipt_long_rounded,
//             label: locale.nav_orders,
//           ),
//           HomeNavItem(
//             icon:  Icons.person_outline_rounded,
//             label: locale.nav_profile,
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/feature/app_section/widget/home_bottom_nav_bar.dart';
import 'package:zadana_user_v3/feature/home/presentation/pages/home_screen.dart';
import 'package:zadana_user_v3/feature/profile/presentation/pages/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _navIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),                          // مقاضي
    Center(child: Text('مطاعم')),
    Center(child: Text('جمال')),
    Center(child: Text('صيدلية')),
    Center(child: Text('طلبات')),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _screens[_navIndex],
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
        items: const [
          AppNavItem(
            icon:       Icons.shopping_basket_outlined,
            activeIcon: Icons.shopping_basket_rounded,
            label:      'مقاضي',
          ),
          AppNavItem(
            icon:       Icons.restaurant_outlined,
            activeIcon: Icons.restaurant_rounded,
            label:      'مطاعم',
          ),
          AppNavItem(
            icon:       Icons.face_retouching_natural_outlined,
            activeIcon: Icons.face_retouching_natural,
            label:      'جمال',
          ),
          AppNavItem(
            icon:       Icons.local_pharmacy_outlined,
            activeIcon: Icons.local_pharmacy_rounded,
            label:      'صيدلية',
            showBadge:  true,
            badgeLabel: 'جديد',
          ),
          AppNavItem(
            icon:       Icons.receipt_long_outlined,
            activeIcon: Icons.receipt_long_rounded,
            label:      'طلبات',
          ),
          AppNavItem(
            icon:       Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            label:      'حسابي',
          ),
        ],
      ),
    );
  }
}