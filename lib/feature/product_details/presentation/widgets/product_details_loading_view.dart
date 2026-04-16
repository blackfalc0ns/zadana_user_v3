import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/skeleton_state_widget.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/skeleton_bone.dart';

class ProductDetailsLoadingView extends StatelessWidget {
  const ProductDetailsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SkeletonStateWidget(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBone(height: 28, radius: 12),
            SizedBox(height: Spacing.sm),
            Row(
              children: [
                Expanded(child: SkeletonBone(height: 18, radius: 10)),
                SizedBox(width: Spacing.sm),
                SkeletonBone(width: 88, height: 18, radius: 10),
              ],
            ),
            SizedBox(height: Spacing.lg),
            SkeletonBone(width: 140, height: 20, radius: 10),
            SizedBox(height: Spacing.sm),
            SkeletonBone(height: 14, radius: 8),
            SizedBox(height: Spacing.xs),
            SkeletonBone(height: 14, radius: 8),
            SizedBox(height: Spacing.xs),
            SkeletonBone(width: 220, height: 14, radius: 8),
            SizedBox(height: Spacing.lg),
            Row(
              children: [
                SkeletonBone(width: 110, height: 20, radius: 10),
                Spacer(),
                SkeletonBone(width: 90, height: 20, radius: 10),
              ],
            ),
            SizedBox(height: Spacing.base),
            _HorizontalSkeletonList(
              height: 120,
              itemWidth: 145,
              itemBuilder: _VendorPriceSkeletonCard.new,
            ),
            SizedBox(height: Spacing.lg),
            SkeletonBone(width: 120, height: 20, radius: 10),
            SizedBox(height: Spacing.base),
            _HorizontalSkeletonList(
              height: 140,
              itemWidth: 130,
              itemBuilder: _SimilarProductSkeletonCard.new,
            ),
            SizedBox(height: 110),
          ],
        ),
      ),
    );
  }
}

class _HorizontalSkeletonList extends StatelessWidget {
  const _HorizontalSkeletonList({
    required this.height,
    required this.itemWidth,
    required this.itemBuilder,
  });

  final double height;
  final double itemWidth;
  final Widget Function(double itemWidth) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
        itemBuilder: (_, _) => itemBuilder(itemWidth),
      ),
    );
  }
}

class _VendorPriceSkeletonCard extends StatelessWidget {
  const _VendorPriceSkeletonCard(this.width);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(12),
      child: const Column(
        children: [
          SkeletonBone(width: 40, height: 40, radius: 10),
          SizedBox(height: 10),
          SkeletonBone(height: 12, radius: 8),
          SizedBox(height: 8),
          SkeletonBone(width: 70, height: 16, radius: 8),
        ],
      ),
    );
  }
}

class _SimilarProductSkeletonCard extends StatelessWidget {
  const _SimilarProductSkeletonCard(this.width);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(8),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBone(height: 55, radius: 12),
          SizedBox(height: 10),
          SkeletonBone(height: 12, radius: 8),
          Spacer(),
          SkeletonBone(width: 70, height: 14, radius: 8),
        ],
      ),
    );
  }
}
