import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';

class BannerDotsIndicator extends StatelessWidget {
  const BannerDotsIndicator({
    super.key,
    required this.itemCount,
    required this.currentPage,
    this.activeColor,
    this.inactiveColor,
    this.dotSize = 8,
    this.activeDotWidth = 20,
  });

  final int itemCount;
  final int currentPage;
  final Color? activeColor;
  final Color? inactiveColor;
  final double dotSize;
  final double activeDotWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => _BannerDot(
          isActive: currentPage == index,
          activeColor: activeColor ?? AppColors.primary,
          inactiveColor:
              inactiveColor ?? AppColors.primary.withValues(alpha: 0.25),
          dotSize: dotSize,
          activeDotWidth: activeDotWidth,
        ),
      ),
    );
  }
}

class _BannerDot extends StatelessWidget {
  const _BannerDot({
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.dotSize,
    required this.activeDotWidth,
  });

  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final double dotSize;
  final double activeDotWidth;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isActive ? activeDotWidth : dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inactiveColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
