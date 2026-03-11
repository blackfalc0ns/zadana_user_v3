import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';

class BannerTag extends StatelessWidget {
  const BannerTag({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 10,
  });

  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          color: textColor ?? AppColors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class BannerTitle extends StatelessWidget {
  const BannerTitle({
    super.key,
    required this.text,
    this.color,
    this.fontSize = 15,
    this.maxLines = 2,
  });

  final String text;
  final Color? color;
  final double fontSize;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.h2.copyWith(
        color: color ?? AppColors.white,
        height: 1.1,
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        shadows: [
          Shadow(
            color: AppColors.black.withValues(alpha: 0.8),
            blurRadius: 4,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
class BannerSubtitle extends StatelessWidget {
  const BannerSubtitle({
    super.key,
    required this.text,
    this.color,
    this.fontSize = 11,
    this.maxLines = 1,
  });

  final String text;
  final Color? color;
  final double fontSize;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.bodyMedium.copyWith(
        color: color ?? AppColors.white,
        fontSize: fontSize,
        height: 1.2,
        fontWeight: FontWeight.w600,
        shadows: [
          Shadow(
            color: AppColors.black.withValues(alpha: 0.8),
            blurRadius: 3,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class BannerActionButton extends StatelessWidget {
  const BannerActionButton({
    super.key,
    required this.text,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 11,
  });

  final String text;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: AppTextStyles.labelMedium.copyWith(
            color: textColor ?? AppColors.primary,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}