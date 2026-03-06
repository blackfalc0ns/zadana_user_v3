import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';

/// بطاقة شيمر واحدة — reusable في أي مكان
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({
    super.key,
    required this.animation,
    this.aspectRatio = 0.82,
  });

  final Animation<double> animation;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Image area ──────────────────────────────────────
            Expanded(
              child: _shimmerBlock(
                width: double.infinity,
                height: double.infinity,
                screenWidth: screenWidth,
                borderRadius: 0,
              ),
            ),

            // ── Labels ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(Spacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmerBlock(
                    width: double.infinity,
                    height: 12,
                    screenWidth: screenWidth,
                  ),
                  const SizedBox(height: 6),
                  _shimmerBlock(
                    width: 60,
                    height: 10,
                    screenWidth: screenWidth,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBlock({
    required double width,
    required double height,
    required double screenWidth,
    double borderRadius = 4,
  }) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: const [
          AppColors.shimmerBase,
          AppColors.shimmerHighlight,
          AppColors.shimmerBase,
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: _SlideTransform(animation.value, screenWidth),
      ).createShader(Rect.fromLTWH(0, 0, screenWidth, bounds.height)),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.shimmerBase,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

// ── Gradient slide transform ──────────────────────────────────────
class _SlideTransform extends GradientTransform {
  const _SlideTransform(this.percent, this.width);
  final double percent;
  final double width;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(width * percent, 0.0, 0.0);
}