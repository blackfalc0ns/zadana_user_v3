import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/widgets/skeleton_colors.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_loading_skeleton.dart'
    show Bone, ShimmerEffect;

class PaymentLoadingView extends StatelessWidget {
  const PaymentLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          child: ShimmerEffect(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.screenH,
                vertical: Spacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PaymentProgressSkeleton(),
                  SizedBox(height: Spacing.base),
                  _PaymentCardSkeleton(height: 176),
                  SizedBox(height: Spacing.md),
                  _PaymentCardSkeleton(height: 118),
                  SizedBox(height: Spacing.md),
                  _PaymentCardSkeleton(height: 132),
                  SizedBox(height: Spacing.md),
                  _PaymentCardSkeleton(height: 164),
                  SizedBox(height: Spacing.md),
                  _PaymentCardSkeleton(height: 110),
                  SizedBox(height: Spacing.md),
                  _PaymentCardSkeleton(height: 196),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.screenH,
              Spacing.sm,
              Spacing.screenH,
              Spacing.md,
            ),
            child: ShimmerEffect(
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: SkeletonColors.base(context),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentProgressSkeleton extends StatelessWidget {
  const _PaymentProgressSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Bone(height: 10, radius: 999)),
        SizedBox(width: Spacing.sm),
        Expanded(child: Bone(height: 10, radius: 999)),
        SizedBox(width: Spacing.sm),
        Expanded(child: Bone(height: 10, radius: 999)),
      ],
    );
  }
}

class _PaymentCardSkeleton extends StatelessWidget {
  const _PaymentCardSkeleton({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: SkeletonColors.card(context),
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: SkeletonColors.border(context), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone(width: 140, height: 18, radius: 999),
          SizedBox(height: Spacing.md),
          Bone(width: double.infinity, height: 16, radius: 999),
          SizedBox(height: Spacing.sm),
          Bone(width: double.infinity, height: 16, radius: 999),
          SizedBox(height: Spacing.sm),
          Bone(width: 180, height: 16, radius: 999),
        ],
      ),
    );
  }
}
