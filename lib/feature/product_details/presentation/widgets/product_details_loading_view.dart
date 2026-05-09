import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/skeleton_state_widget.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/skeleton_bone.dart';

class ProductDetailsLoadingView extends StatelessWidget {
  const ProductDetailsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: const SkeletonStateWidget(
        child: SafeArea(
          child: Column(
            children: [
              _LoadingAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeroImageSkeleton(),
                      _HeaderSectionSkeleton(),
                      _DescriptionSectionSkeleton(),
                      SizedBox(height: Spacing.base),
                      _PriceComparisonSkeleton(),
                      SizedBox(height: Spacing.base),
                      _SimilarProductsSkeleton(),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              _BottomActionsSkeleton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingAppBar extends StatelessWidget {
  const _LoadingAppBar();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        Spacing.base,
        Spacing.sm,
        Spacing.base,
        Spacing.sm,
      ),
      child: Row(
        children: [
          SkeletonBone(width: 22, height: 22, radius: 11),
          SizedBox(width: Spacing.base),
          Expanded(child: SkeletonBone(height: 24, radius: 12)),
          SizedBox(width: Spacing.base),
          SkeletonBone(width: 28, height: 28, radius: 14),
        ],
      ),
    );
  }
}

class _HeroImageSkeleton extends StatelessWidget {
  const _HeroImageSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(Spacing.sm),
      child: SkeletonBone(
        width: double.infinity,
        height: 250,
        radius: Spacing.cardRadius,
      ),
    );
  }
}

class _HeaderSectionSkeleton extends StatelessWidget {
  const _HeaderSectionSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(Spacing.base),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBone(height: 20, radius: 10),
                SizedBox(height: 10),
                SkeletonBone(width: 64, height: 24, radius: 6),
              ],
            ),
          ),
          SizedBox(width: Spacing.base),
          _QuantitySelectorSkeleton(),
        ],
      ),
    );
  }
}

class _QuantitySelectorSkeleton extends StatelessWidget {
  const _QuantitySelectorSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SkeletonBone(width: 32, height: 32, radius: 8),
        SizedBox(width: 8),
        SkeletonBone(width: 46, height: 32, radius: 8),
        SizedBox(width: 8),
        SkeletonBone(width: 32, height: 32, radius: 8),
      ],
    );
  }
}

class _DescriptionSectionSkeleton extends StatelessWidget {
  const _DescriptionSectionSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBone(width: 140, height: 18, radius: 9),
          SizedBox(height: Spacing.sm),
          SkeletonBone(height: 14, radius: 8),
          SizedBox(height: Spacing.xs),
          SkeletonBone(height: 14, radius: 8),
          SizedBox(height: Spacing.xs),
          SkeletonBone(width: 220, height: 14, radius: 8),
        ],
      ),
    );
  }
}

class _PriceComparisonSkeleton extends StatelessWidget {
  const _PriceComparisonSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBone(width: 28, height: 28, radius: 8),
              SizedBox(width: 8),
              SkeletonBone(width: 180, height: 18, radius: 9),
            ],
          ),
          SizedBox(height: 20),
          _HorizontalSkeletonList(
            height: 138,
            itemWidth: 145,
            itemBuilder: _VendorPriceSkeletonCard.new,
          ),
        ],
      ),
    );
  }
}

class _SimilarProductsSkeleton extends StatelessWidget {
  const _SimilarProductsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(Spacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBone(width: 130, height: 20, radius: 10),
          SizedBox(height: Spacing.sm),
          _HorizontalSkeletonList(
            height: 140,
            itemWidth: 130,
            itemBuilder: _SimilarProductSkeletonCard.new,
          ),
        ],
      ),
    );
  }
}

class _BottomActionsSkeleton extends StatelessWidget {
  const _BottomActionsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        Spacing.base,
        Spacing.sm,
        Spacing.base,
        Spacing.base,
      ),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: const SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(child: SkeletonBone(height: 48, radius: 14)),
            SizedBox(width: Spacing.sm),
            Expanded(child: SkeletonBone(height: 48, radius: 14)),
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
          SkeletonBone(width: 72, height: 72, radius: 16),
          SizedBox(height: 12),
          SkeletonBone(height: 12, radius: 8),
          SizedBox(height: 8),
          SkeletonBone(width: 82, height: 16, radius: 8),
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
          SkeletonBone(height: 74, radius: 12),
          SizedBox(height: 10),
          SkeletonBone(height: 12, radius: 8),
          SizedBox(height: 6),
          SkeletonBone(width: 86, height: 12, radius: 8),
          Spacer(),
          SkeletonBone(width: 70, height: 14, radius: 8),
        ],
      ),
    );
  }
}
