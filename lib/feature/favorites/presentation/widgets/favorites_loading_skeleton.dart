import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';

class FavoritesLoadingSkeleton extends StatefulWidget {
  const FavoritesLoadingSkeleton({super.key});

  @override
  State<FavoritesLoadingSkeleton> createState() =>
      _FavoritesLoadingSkeletonState();
}

class _FavoritesLoadingSkeletonState extends State<FavoritesLoadingSkeleton>
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
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: 90, left: 12, right: 12),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 15,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.86,
          crossAxisSpacing: Spacing.xss,
          mainAxisSpacing: Spacing.xss,
        ),
        itemBuilder: (_, index) => _FavoriteCardSkeleton(index: index),
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

class _FavoriteCardSkeleton extends StatelessWidget {
  const _FavoriteCardSkeleton({required this.index});

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
                          0 => 74,
                          1 => 68,
                          2 => 78,
                          _ => 64,
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
                                _Bone(width: 42, height: 10, radius: 999),
                                SizedBox(height: 4),
                                _Bone(width: 34, height: 10, radius: 999),
                              ],
                            ),
                          ),
                          SizedBox(width: 4),
                          _Bone(width: 30, height: 30, radius: 999),
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
            child: _Bone(width: 30, height: 30, radius: 999),
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
