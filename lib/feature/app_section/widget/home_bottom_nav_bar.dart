import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';

class HomeNavItem {
  final IconData icon;
  final String label;

  const HomeNavItem({required this.icon, required this.label});
}

class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    required this.onCartTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<HomeNavItem> items; // 4 items فقط (بدون Cart)
  final VoidCallback onCartTap;

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
                onTap: onCartTap,
                child: Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.40),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.cartPlus,
                    color: AppColors.white,
                    size:20,
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
      final item = items[index];
      final active = currentIndex == index;

      return Expanded(
        child: GestureDetector(
          onTap: () => onTap(index),
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                size: 22,
                color: active ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(height: 3),
              Text(
                item.label,
                style: AppTextStyles.bodySmall.copyWith(
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
