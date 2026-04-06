import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/layout/product_grid_layout.dart';

class CategoryLoadingSkeleton extends StatefulWidget {
  const CategoryLoadingSkeleton({super.key});

  @override
  State<CategoryLoadingSkeleton> createState() =>
      _CategoryLoadingSkeletonState();
}

class _CategoryLoadingSkeletonState extends State<CategoryLoadingSkeleton>
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
    return _ShimmerWrapper(
      controller: _controller,
      child: Column(
        children: const [
          _SearchSkeleton(),
          SizedBox(height: Spacing.md),
          _ChipsSkeleton(),
          SizedBox(height: Spacing.sm),
          Expanded(child: _ProductsSkeleton()),
        ],
      ),
    );
  }
}

class _ShimmerWrapper extends StatelessWidget {
  const _ShimmerWrapper({required this.controller, required this.child});

  final AnimationController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-2.0 + (controller.value * 4), -0.5),
              end: Alignment(0.0 + (controller.value * 4), 0.5),
              colors: [
                AppColors.shimmerBase,
                AppColors.shimmerHighlight.withValues(alpha: 0.5),
                AppColors.shimmerBase,
              ],
              stops: const [0.35, 0.5, 0.65],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: child,
    );
  }
}

class _SearchSkeleton extends StatelessWidget {
  const _SearchSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.md),
      child: Row(
        children: const [
          Expanded(child: _Bone(height: 40, radius: Spacing.cardRadius)),
          SizedBox(width: 6),
          _Bone(width: 42, height: 40, radius: 8),
        ],
      ),
    );
  }
}

class _ChipsSkeleton extends StatelessWidget {
  const _ChipsSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
        itemBuilder: (_, index) =>
            _Bone(width: index == 0 ? 88 : 78, height: 36, radius: 999),
      ),
    );
  }
}

class _ProductsSkeleton extends StatelessWidget {
  const _ProductsSkeleton();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = ProductGridLayout.resolve(constraints.maxWidth);

        return GridView.builder(
          padding: const EdgeInsets.only(
            top: 4,
            left: Spacing.md,
            right: Spacing.md,
            bottom: 85,
          ),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 15,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: layout.crossAxisCount,
            childAspectRatio: layout.childAspectRatio,
            crossAxisSpacing: Spacing.xss,
            mainAxisSpacing: Spacing.xss,
          ),
          itemBuilder: (_, index) => _ProductCardSkeleton(index: index),
        );
      },
    );
  }
}

class _ProductCardSkeleton extends StatelessWidget {
  const _ProductCardSkeleton({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Bone(height: 75, radius: Spacing.cardRadius),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(7, 7, 7, 3.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bone(
                        width: switch (index % 4) {
                          0 => 72,
                          1 => 64,
                          2 => 78,
                          _ => 68,
                        },
                        height: 12,
                        radius: 999,
                      ),
                      const Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Bone(width: 40, height: 10, radius: 999),
                                SizedBox(height: 4),
                                _Bone(width: 32, height: 10, radius: 999),
                              ],
                            ),
                          ),
                          SizedBox(width: 4),
                          _Bone(width: 28, height: 28, radius: 999),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Positioned(
            top: 4,
            right: 4,
            child: _Bone(width: 28, height: 28, radius: 999),
          ),
        ],
      ),
    );
  }
}

class _Bone extends StatelessWidget {
  const _Bone({this.width, required this.height, required this.radius});

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
