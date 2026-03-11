import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';

class BannerContainer extends StatelessWidget {
  const BannerContainer({
    super.key,
    required this.child,
    this.height = 180,
    this.margin,
  });

  final Widget child;
  final double height;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: Spacing.screenH),
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}