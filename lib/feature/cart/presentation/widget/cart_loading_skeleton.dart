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
      child: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 170),
            child: _CartContentSkeleton(),
          ),
          const Positioned(
            bottom: 90,
            left: 0,
            right: 0,
            child: _SelectVendorBottomSkeleton(),
          ),
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
                AppColors.shimmerHighlight.withOpacity(0.5),
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

class _CartContentSkeleton extends StatelessWidget {
  const _CartContentSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _VendorSelectorSkeleton(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _VendorPromptSkeleton(),
        ),
        SizedBox(height: 4),
        Divider(height: 4, color: AppColors.border),
        Expanded(child: _CartItemsSkeleton()),
      ],
    );
  }
}

class _VendorSelectorSkeleton extends StatelessWidget {
  const _VendorSelectorSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
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
            color: AppColors.primary.withOpacity(0.2),
          ),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              itemCount: 7,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (_, index) => _VendorChipSkeleton(index: index),
            ),
          ),
        ],
      ),
    );
  }
}

class _VendorChipSkeleton extends StatelessWidget {
  const _VendorChipSkeleton({required this.index});

  final int index;

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
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Bone(width: 20, height: 20, radius: 999),
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
          ),
        ],
      ),
    );
  }
}

class _VendorPromptSkeleton extends StatelessWidget {
  const _VendorPromptSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const _Bone(width: 36, height: 36, radius: 8),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _Bone(width: 190, height: 16, radius: 999),
                SizedBox(height: 6),
                _Bone(width: 150, height: 12, radius: 999),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const _Bone(width: 24, height: 24, radius: 999),
        ],
      ),
    );
  }
}

class _CartItemsSkeleton extends StatelessWidget {
  const _CartItemsSkeleton();

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
              color: AppColors.shadow.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            const _Bone(width: 80, height: 80, radius: Spacing.cardRadius),
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
                  ),
                  const SizedBox(height: 4),
                  const _Bone(width: 132, height: 11, radius: 999),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      _Bone(width: 32, height: 32, radius: 6),
                      SizedBox(width: 12),
                      _Bone(width: 48, height: 32, radius: 6),
                      SizedBox(width: 12),
                      _Bone(width: 32, height: 32, radius: 6),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Align(
              alignment: Alignment.topCenter,
              child: _Bone(width: 36, height: 36, radius: 6),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectVendorBottomSkeleton extends StatelessWidget {
  const _SelectVendorBottomSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: const [
              _Bone(width: 16, height: 16, radius: 999),
              SizedBox(width: 5),
              _Bone(width: 52, height: 12, radius: 999),
              Spacer(),
              _Bone(width: 138, height: 12, radius: 999),
            ],
          ),
          const SizedBox(height: 8),
          const _Bone(height: 36, radius: 8),
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
