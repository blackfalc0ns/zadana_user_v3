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
                  _PaymentCardSkeleton(height: 120),
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          const titleHeight = 18.0;
          const lineHeight = 16.0;
          const lineCount = 3;
          const totalBoneHeight = titleHeight + (lineHeight * lineCount);
          final availableGapSpace = (constraints.maxHeight - totalBoneHeight)
              .clamp(0.0, 40.0);
          final largeGap = availableGapSpace >= 20 ? Spacing.md : Spacing.sm;
          final smallGap = ((availableGapSpace - largeGap) / 2).clamp(4.0, 8.0);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Bone(width: 140, height: titleHeight, radius: 999),
              SizedBox(height: largeGap),
              const Bone(
                width: double.infinity,
                height: lineHeight,
                radius: 999,
              ),
              SizedBox(height: smallGap),
              const Bone(
                width: double.infinity,
                height: lineHeight,
                radius: 999,
              ),
              SizedBox(height: smallGap),
              const Bone(width: 180, height: lineHeight, radius: 999),
            ],
          );
        },
      ),
    );
  }
}

/// Replaces checkout details while a fulfillment-type change is in flight.
class CheckoutRefreshShimmer extends StatelessWidget {
  const CheckoutRefreshShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerEffect(
      child: Column(
        children: [
          _PaymentCardSkeleton(height: 118),
          SizedBox(height: Spacing.md),
          _PaymentCardSkeleton(height: 132),
          SizedBox(height: Spacing.md),
          _PaymentCardSkeleton(height: 164),
          SizedBox(height: Spacing.md),
          _PaymentCardSkeleton(height: 120),
          SizedBox(height: Spacing.md),
          _PaymentCardSkeleton(height: 196),
        ],
      ),
    );
  }
}
