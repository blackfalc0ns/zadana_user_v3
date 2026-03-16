import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';

/// ─── Section Title + "See All" ───
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.actionLabel,
    this.onActionTap,
    this.titleColor,
    this.actionColor,
    this.horizontalPadding,
  });

  final String title;
  final String actionLabel;
  final VoidCallback? onActionTap;
  final Color? titleColor;
  final Color? actionColor;
  final double? horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? Spacing.screenH,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              color: titleColor,
              fontSize: FontSize.size15,
            ),
          ),

          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionLabel,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size12,
                color: actionColor ?? AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
