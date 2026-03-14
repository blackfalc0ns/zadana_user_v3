import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';

class BannerContainer extends StatelessWidget {
  const BannerContainer({
    super.key,
    required this.child,
    this.height = 140, // تقليل الطول من 180 إلى 140
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
            blurRadius: 4, // تقليل الشادو من 8 إلى 4
            offset: const Offset(0, 1), // تقليل الإزاحة من 2 إلى 1
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}