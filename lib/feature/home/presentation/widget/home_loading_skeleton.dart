import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';

class HomeLoadingSkeleton extends StatefulWidget {
  const HomeLoadingSkeleton({super.key});

  @override
  State<HomeLoadingSkeleton> createState() => _HomeLoadingSkeletonState();
}

class _HomeLoadingSkeletonState extends State<HomeLoadingSkeleton>
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
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.2 + (_controller.value * 2), 0),
              end: Alignment(-0.2 + (_controller.value * 2), 0),
              colors: const [
                AppColors.shimmerBase,
                AppColors.shimmerHighlight,
                AppColors.shimmerBase,
              ],
              stops: const [0.1, 0.3, 0.4],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: CustomScrollView(
            key: const PageStorageKey<String>('home_loading_scroll_view'),
            slivers: const [
              SliverToBoxAdapter(child: SizedBox(height: Spacing.sm)),
              SliverToBoxAdapter(child: _SearchBarSkeleton()),
              SliverToBoxAdapter(child: SizedBox(height: Spacing.base)),
              SliverToBoxAdapter(child: _BannerSkeleton()),
              SliverToBoxAdapter(child: SizedBox(height: Spacing.lg)),
              SliverToBoxAdapter(child: _CategoriesSectionSkeleton()),
              SliverToBoxAdapter(child: SizedBox(height: Spacing.lg)),
              SliverToBoxAdapter(child: _SectionSkeleton(cardCount: 3)),
              SliverToBoxAdapter(child: SizedBox(height: Spacing.lg)),
              SliverToBoxAdapter(child: _SectionSkeleton(cardCount: 3)),
              SliverToBoxAdapter(child: SizedBox(height: Spacing.lg)),
              SliverToBoxAdapter(child: _SectionSkeleton(cardCount: 3)),
              SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      },
    );
  }
}

class _SectionSkeleton extends StatelessWidget {
  const _SectionSkeleton({required this.cardCount});

  final int cardCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              _Bone(width: 120, height: 18, radius: 999),
              Spacer(),
              _Bone(width: 52, height: 14, radius: 999),
            ],
          ),
          const SizedBox(height: Spacing.base),
          SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cardCount,
              separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
              itemBuilder: (_, _) => const _ProductCardSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBarSkeleton extends StatelessWidget {
  const _SearchBarSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.base),
      child: _Bone(height: 48, radius: 16),
    );
  }
}

class _BannerSkeleton extends StatelessWidget {
  const _BannerSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.base),
      child: _Bone(height: 150, radius: 20),
    );
  }
}

class _ProductCardSkeleton extends StatelessWidget {
  const _ProductCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: const [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Bone(height: 75, radius: Spacing.cardRadius),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(7, 7, 7, 3.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bone(width: 76, height: 12, radius: 999),
                      Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Bone(width: 44, height: 10, radius: 999),
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
          Positioned(
            top: 4,
            right: 4,
            child: _Bone(width: 30, height: 30, radius: 999),
          ),
        ],
      ),
    );
  }
}

class _CategoriesSectionSkeleton extends StatelessWidget {
  const _CategoriesSectionSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              _Bone(width: 132, height: 18, radius: 999),
              Spacer(),
              _Bone(width: 52, height: 14, radius: 999),
            ],
          ),
          const SizedBox(height: Spacing.md),
          SizedBox(
            height: 88,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
              itemBuilder: (_, _) => const _CategoryChipSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChipSkeleton extends StatelessWidget {
  const _CategoryChipSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.xs,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Bone(width: 36, height: 36, radius: 999),
          SizedBox(height: Spacing.xs),
          _Bone(width: 44, height: 10, radius: 999),
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
  });

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
