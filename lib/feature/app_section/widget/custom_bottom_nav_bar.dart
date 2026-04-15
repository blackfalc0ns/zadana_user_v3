import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key, required this.navBarConfig});
  final NavBarConfig navBarConfig;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      height: 60,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: color.surface,
                boxShadow: [
                  BoxShadow(
                    color: color.shadow.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ..._buildItems(context, 0, 2),
                  const Expanded(child: SizedBox()),
                  ..._buildItems(context, 2, 4),
                ],
              ),
            ),
          ),
          Positioned(
            top: -18,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => navBarConfig.onItemSelected(4),
                child: Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: navBarConfig.selectedIndex == 4
                        ? color.primary
                        : color.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.primary.withValues(alpha: 0.40),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.cartPlus,
                    color: color.onPrimary,
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
    final color = context.colorScheme;
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
                color: active
                    ? color.primary
                    : color.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 3),
              Text(
                item.title ?? '',
                style: getMediumStyle(
                  fontSize: FontSize.size10,
                  fontFamily: FontConstant.cairo,
                  color: active
                      ? color.primary
                      : color.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
