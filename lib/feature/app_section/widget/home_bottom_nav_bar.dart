// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:zadana_user_v3/config/theme/colors.dart';
// import 'package:zadana_user_v3/config/theme/text_styles.dart';

// class HomeNavItem {
//   final IconData icon;
//   final String label;

//   const HomeNavItem({required this.icon, required this.label});
// }

// class HomeBottomNavBar extends StatelessWidget {
//   const HomeBottomNavBar({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//     required this.items,
//     required this.onCartTap,
//   });

//   final int currentIndex;
//   final ValueChanged<int> onTap;
//   final List<HomeNavItem> items; // 4 items فقط (بدون Cart)
//   final VoidCallback onCartTap;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 72,
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           // ── Bar background ────────────────────────────────────
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: AppColors.surface,
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.shadow,
//                     blurRadius: 12,
//                     offset: const Offset(0, -2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   // Left 2 items
//                   ..._buildItems(context, 0, 2),
//                   // Center placeholder for cart
//                   const Expanded(child: SizedBox()),
//                   // Right 2 items
//                   ..._buildItems(context, 2, 4),
//                 ],
//               ),
//             ),
//           ),

//           // ── Floating cart button ──────────────────────────────
//           Positioned(
//             top: -18,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: GestureDetector(
//                 onTap: onCartTap,
//                 child: Container(
//                   width: 56,
//                   height: 56,
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: AppColors.primary,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: AppColors.primary.withOpacity(0.40),
//                         blurRadius: 12,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: const FaIcon(
//                     FontAwesomeIcons.cartPlus,
//                     color: AppColors.white,
//                     size:20,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   List<Widget> _buildItems(BuildContext context, int from, int to) {
//     return List.generate(to - from, (i) {
//       final index = from + i;
//       final item = items[index];
//       final active = currentIndex == index;

//       return Expanded(
//         child: GestureDetector(
//           onTap: () => onTap(index),
//           behavior: HitTestBehavior.opaque,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 item.icon,
//                 size: 22,
//                 color: active ? AppColors.primary : AppColors.textSecondary,
//               ),
//               const SizedBox(height: 3),
//               Text(
//                 item.label,
//                 style: AppTextStyles.bodySmall.copyWith(
//                   fontSize: 10,
//                   color: active ? AppColors.primary : AppColors.textSecondary,
//                   fontWeight: active ? FontWeight.w600 : FontWeight.w400,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';

class AppNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool showBadge;
  final String? badgeLabel;

  const AppNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.showBadge = false,
    this.badgeLabel,
  });
}

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  final int currentIndex;
  final List<AppNavItem> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 62,
            child: Row(
              children: List.generate(items.length, (i) {
                final item = items[i];
                final isSelected = i == currentIndex;

                return Expanded(
                  child: _NavBarItem(
                    item: item,
                    isSelected: isSelected,
                    onTap: () => onTap(i),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Single nav item ───────────────────────────────────────────────
class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final AppNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Icon + badge ─────────────────────────────────────
          Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  size: 22,
                ),
              ),

              // Badge
              if (item.showBadge)
                Positioned(
                  top: -2,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.badgeLabel ?? 'جديد',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 2),

          // ── Label ─────────────────────────────────────────────
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 10,
              fontWeight:
                  isSelected ? FontWeight.w700 : FontWeight.w400,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
            child: Text(item.label),
          ),
        ],
      ),
    );
  }
}
