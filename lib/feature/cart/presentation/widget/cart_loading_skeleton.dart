import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';

class CartLoadingSkeleton extends StatefulWidget {
  const CartLoadingSkeleton({super.key});

  @override
  State<CartLoadingSkeleton> createState() => _CartLoadingSkeletonState();
}

class _CartLoadingSkeletonState extends State<CartLoadingSkeleton>
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
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 170),
              child: _CartContentSkeleton(shimmerValue: _controller.value),
            ),
            Positioned(
              bottom: 90,
              left: 0,
              right: 0,
              child: _SelectVendorBottomSkeleton(
                shimmerValue: _controller.value,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CartContentSkeleton extends StatelessWidget {
  const _CartContentSkeleton({required this.shimmerValue});

  final double shimmerValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _VendorSelectorSkeleton(shimmerValue: shimmerValue),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _VendorPromptSkeleton(shimmerValue: shimmerValue),
        ),
        const SizedBox(height: 4),
        const Divider(height: 4, color: AppColors.border),
        Expanded(
          child: _CartItemsSkeleton(shimmerValue: shimmerValue),
        ),
      ],
    );
  }
}

class _VendorSelectorSkeleton extends StatelessWidget {
  const _VendorSelectorSkeleton({required this.shimmerValue});

  final double shimmerValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 2,
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              itemCount: 7,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (_, index) => _VendorChipSkeleton(
                index: index,
                shimmerValue: shimmerValue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VendorChipSkeleton extends StatelessWidget {
  const _VendorChipSkeleton({
    required this.index,
    required this.shimmerValue,
  });

  final int index;
  final double shimmerValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Bone(width: 20, height: 20, radius: 999, shimmerValue: shimmerValue),
          const SizedBox(width: 8),
          _Bone(
            width: switch (index) {
              0 => 58,
              1 => 52,
              2 => 66,
              3 => 50,
              4 => 60,
              5 => 54,
              _ => 48,
            },
            height: 14,
            radius: 999,
            shimmerValue: shimmerValue,
          ),
        ],
      ),
    );
  }
}

class _VendorPromptSkeleton extends StatelessWidget {
  const _VendorPromptSkeleton({required this.shimmerValue});

  final double shimmerValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          _Bone(width: 36, height: 36, radius: 8, shimmerValue: shimmerValue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Bone(
                  width: 190,
                  height: 16,
                  radius: 999,
                  shimmerValue: shimmerValue,
                ),
                const SizedBox(height: 6),
                _Bone(
                  width: 150,
                  height: 12,
                  radius: 999,
                  shimmerValue: shimmerValue,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _Bone(width: 24, height: 24, radius: 999, shimmerValue: shimmerValue),
        ],
      ),
    );
  }
}

class _CartItemsSkeleton extends StatelessWidget {
  const _CartItemsSkeleton({required this.shimmerValue});

  final double shimmerValue;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(height: 3),
      itemBuilder: (_, index) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.06),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            _Bone(
              width: 80,
              height: 80,
              radius: Spacing.cardRadius,
              shimmerValue: shimmerValue,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Bone(
                    width: switch (index) {
                      0 => 92,
                      1 => 70,
                      2 => 82,
                      3 => 64,
                      _ => 88,
                    },
                    height: 14,
                    radius: 999,
                    shimmerValue: shimmerValue,
                  ),
                  const SizedBox(height: 4),
                  _Bone(
                    width: 132,
                    height: 11,
                    radius: 999,
                    shimmerValue: shimmerValue,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _Bone(
                        width: 32,
                        height: 32,
                        radius: 6,
                        shimmerValue: shimmerValue,
                      ),
                      const SizedBox(width: 12),
                      _Bone(
                        width: 48,
                        height: 32,
                        radius: 6,
                        shimmerValue: shimmerValue,
                      ),
                      const SizedBox(width: 12),
                      _Bone(
                        width: 32,
                        height: 32,
                        radius: 6,
                        shimmerValue: shimmerValue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Align(
              alignment: Alignment.topCenter,
              child: _Bone(
                width: 36,
                height: 36,
                radius: 6,
                shimmerValue: shimmerValue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectVendorBottomSkeleton extends StatelessWidget {
  const _SelectVendorBottomSkeleton({required this.shimmerValue});

  final double shimmerValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _Bone(
                width: 16,
                height: 16,
                radius: 999,
                shimmerValue: shimmerValue,
              ),
              const SizedBox(width: 5),
              _Bone(
                width: 52,
                height: 12,
                radius: 999,
                shimmerValue: shimmerValue,
              ),
              const Spacer(),
              _Bone(
                width: 138,
                height: 12,
                radius: 999,
                shimmerValue: shimmerValue,
              ),
            ],
          ),
          const SizedBox(height: 8),
          _Bone(height: 36, radius: 8, shimmerValue: shimmerValue),
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
