import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class DrawerMenuItem extends StatelessWidget {
  const DrawerMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.textColor,
    this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? textColor;
  final Color? iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Padding(
      padding: const EdgeInsets.all(2),
      child: ListTile(
        minTileHeight: 10,
        leading: FaIcon(
          icon,
          color: iconColor ?? textColor ?? color.onSurface,
          size: 18,
        ),
        title: Text(
          title,
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size12,
            color: textColor ?? color.onSurface,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size10,
                  color: color.onSurfaceVariant,
                ),
              )
            : null,
        trailing: FaIcon(
          FontAwesomeIcons.chevronLeft,
          color: color.onSurfaceVariant,
          size: 12,
        ),
        onTap: onTap,
        // contentPadding: const EdgeInsets.symmetric(
        //   horizontal: Spacing.sm,
        //   vertical: Spacing.xs,
        // ),
      ),
    );
  }
}