import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';

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
        return Column(
          children: [
            _SearchSkeleton(shimmerValue: _controller.value),
            const SizedBox(height: Spacing.md),
            _ChipsSkeleton(shimmerValue: _controller.value),
            const SizedBox(height: Spacing.sm),
            Expanded(
              child: _ProductsSkeleton(shimmerValue: _controller.value),
            ),
          ],
        );
      },
    );
  }
}

class _SearchSkeleton extends StatelessWidget {
  const _SearchSkeleton({required this.shimmerValue});

  final double shimmerValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.md),
      child: Row(
        children: [
          Expanded(
            child: _Bone(
              height: 40,
              radius: Spacing.cardRadius,
              shimmerValue: shimmerValue,
            ),
          ),
          const SizedBox(width: 6),
          _Bone(
            width: 42,
            height: 40,
            radius: 8,
            shimmerValue: shimmerValue,
          ),
        ],
      ),
    );
  }
}

class _ChipsSkeleton extends StatelessWidget {
  const _ChipsSkeleton({required this.shimmerValue});

  final double shimmerValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
        itemBuilder: (_, index) => _Bone(
          width: index == 0 ? 88 : 78,
          height: 36,
          radius: 999,
          shimmerValue: shimmerValue,
        ),
      ),
    );
  }
}

class _ProductsSkeleton extends StatelessWidget {
  const _ProductsSkeleton({required this.shimmerValue});

  final double shimmerValue;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(
        top: 4,
        left: Spacing.md,
        right: Spacing.md,
        bottom: 85,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 15,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.86,
        crossAxisSpacing: Spacing.xss,
        mainAxisSpacing: Spacing.xss,
      ),
      itemBuilder: (_, index) => _ProductCardSkeleton(
        shimmerValue: shimmerValue,
        index: index,
      ),
    );
  }
}

class _ProductCardSkeleton extends StatelessWidget {
  const _ProductCardSkeleton({
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
                          0 => 72,
                          1 => 64,
                          2 => 78,
                          _ => 68,
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
                                  width: 40,
                                  height: 10,
                                  radius: 999,
                                  shimmerValue: shimmerValue,
                                ),
                                const SizedBox(height: 4),
                                _Bone(
                                  width: 32,
                                  height: 10,
                                  radius: 999,
                                  shimmerValue: shimmerValue,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          _Bone(
                            width: 28,
                            height: 28,
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
              width: 28,
              height: 28,
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
