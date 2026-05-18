import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/widgets/skeleton_colors.dart';

class ShimmerEffect extends StatefulWidget {
  const ShimmerEffect({super.key, required this.child});

  final Widget child;

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = SkeletonColors.base(context);
    final highlightColor = SkeletonColors.highlight(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-2.0 + (_controller.value * 4), -0.5),
              end: Alignment(0.0 + (_controller.value * 4), 0.5),
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.35, 0.5, 0.65],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class BannerSkeleton extends StatelessWidget {
  const BannerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.base),
      child: Bone(height: 150, radius: 20),
    );
  }
}

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key, this.width = 112});

  final double width;

  @override
  Widget build(BuildContext context) {
    final skeletonCardColor = SkeletonColors.card(context);
    final skeletonBorderColor = SkeletonColors.border(context);
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: skeletonCardColor,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: skeletonBorderColor),
      ),
      child: const Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bone(height: 70, radius: Spacing.cardRadius),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(7, 7, 7, 3.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Bone(width: 76, height: 12, radius: 999),
                      Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Bone(width: 44, height: 10, radius: 999),
                                SizedBox(height: 4),
                                Bone(width: 34, height: 10, radius: 999),
                              ],
                            ),
                          ),
                          SizedBox(width: 4),
                          Bone(width: 30, height: 30, radius: 999),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 4,
            right: 4,
            child: Bone(width: 30, height: 30, radius: 999),
          ),
        ],
      ),
    );
  }
}

class CategoriesSectionSkeleton extends StatelessWidget {
  const CategoriesSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Bone(width: 132, height: 18, radius: 999),
              Spacer(),
              Bone(width: 52, height: 14, radius: 999),
            ],
          ),
          const SizedBox(height: Spacing.md),
          SizedBox(
            height: 88,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
              itemBuilder: (_, _) => const CategoryChipSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryChipSkeleton extends StatelessWidget {
  const CategoryChipSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = SkeletonColors.base(context);
    return Container(
      width: 72,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.xs,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Bone(width: 36, height: 36, radius: 999),
          SizedBox(height: Spacing.xs),
          Bone(width: 44, height: 10, radius: 999),
        ],
      ),
    );
  }
}

class Bone extends StatelessWidget {
  const Bone({
    super.key,
    this.width,
    required this.height,
    required this.radius,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final baseColor = SkeletonColors.base(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
