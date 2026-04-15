import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class DrawerMenuItem extends StatelessWidget {
  const DrawerMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.textColor,
    this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? textColor;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 3),
      child: Material(
        color: color.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: ListTile(
            minTileHeight: 10,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: 4,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: color.outline.withValues(alpha: 0.08)),
            ),
            leading: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: FaIcon(icon, color: color.primary, size: 16),
              ),
            ),
            title: Text(
              title,
              style: getMediumStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: textColor ?? color.onSurface,
              ),
            ),
            subtitle: subtitle != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        color: color.onSurface.withValues(alpha: 0.62),
                      ),
                    ),
                  )
                : null,
            trailing:
                trailing ??
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: FaIcon(
                      isRtl
                          ? FontAwesomeIcons.chevronLeft
                          : FontAwesomeIcons.chevronRight,
                      color: color.primary,
                      size: 10,
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
