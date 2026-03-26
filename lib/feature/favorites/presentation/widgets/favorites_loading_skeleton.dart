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
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return GridView.builder(
          padding: const EdgeInsets.only(bottom: 90, left: 12, right: 12),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 15,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.86,
            crossAxisSpacing: Spacing.xss,
            mainAxisSpacing: Spacing.xss,
          ),
          itemBuilder: (_, index) => _FavoriteCardSkeleton(
            shimmerValue: _controller.value,
            index: index,
          ),
        );
      },
    );
  }
}

class _FavoriteCardSkeleton extends StatelessWidget {
  const _FavoriteCardSkeleton({
    required this.shimmerValue,
    required this.index,
  });

  final double shimmerValue;
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
              _Bone(
                height: 75,
                radius: Spacing.cardRadius,
                shimmerValue: shimmerValue,
              ),
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
                        shimmerValue: shimmerValue,
                      ),
                      const Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Bone(
                                  width: 42,
                                  height: 10,
                                  radius: 999,
                                  shimmerValue: shimmerValue,
                                ),
                                const SizedBox(height: 4),
                                _Bone(
                                  width: 34,
                                  height: 10,
                                  radius: 999,
                                  shimmerValue: shimmerValue,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          _Bone(
                            width: 30,
                            height: 30,
                            radius: 999,
                            shimmerValue: shimmerValue,
                          ),
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
            child: _Bone(
              width: 30,
              height: 30,
              radius: 999,
              shimmerValue: shimmerValue,
            ),
          ),
        ],
      ),
    );
  }
}

class _Bone extends StatelessWidget {
  const _Bone({
    this.width,
    required this.height,
    required this.radius,
    required this.shimmerValue,
  });

  final double? width;
  final double height;
  final double radius;
  final double shimmerValue;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment(-1.2 + (shimmerValue * 2), 0),
          end: Alignment(-0.2 + (shimmerValue * 2), 0),
          colors: [
            AppColors.shimmerBase.withValues(alpha: 0.72),
            AppColors.shimmerHighlight.withValues(alpha: 0.48),
            AppColors.shimmerBase.withValues(alpha: 0.72),
          ],
          stops: const [0.1, 0.3, 0.4],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.shimmerBase.withValues(alpha: 0.58),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
