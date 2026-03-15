import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';

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
    return Padding(
      padding: const EdgeInsets.all(2),
      child: ListTile(minTileHeight: 10,
        leading: FaIcon(
          icon,
          color: iconColor ?? textColor ?? AppColors.textPrimary,
          size: 18,
        ),
        title: Text(
          title,
          style: AppTextStyles.labelMedium.copyWith(
            color: textColor ?? AppColors.textPrimary,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        trailing: FaIcon(
          FontAwesomeIcons.chevronLeft,
          color: AppColors.textSecondary,
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