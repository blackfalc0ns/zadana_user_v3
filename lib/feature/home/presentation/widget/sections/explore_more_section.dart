import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_view_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/explore_more_tile.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_loading_skeleton.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/section_header.dart';

class ExploreMoreSection extends StatelessWidget {
  const ExploreMoreSection({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocBuilder<HomeViewModel, HomeState>(
      buildWhen: (previous, current) =>
          previous.exploreMoreSection != current.exploreMoreSection,
      builder: (context, state) {
        if (state.exploreMoreSection.isLoading) {
          return Column(
            children: [
              SectionHeader(
                title: locale.section_explore,
                actionLabel: locale.see_all,
              ),
              const SizedBox(height: Spacing.sm),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: Spacing.screenH),
                child: ShimmerEffect(child: _ExploreMoreListSkeleton()),
              ),
            ],
          );
        }

        final section = state.exploreMoreSection.data;
        if (section?.isActive == false) {
          return const SizedBox.shrink();
        }

        if (state.exploreMoreSection.failure != null &&
            state.exploreMoreSection.data == null) {
          return Column(
            children: [
              SectionHeader(
                title: locale.section_explore,
                actionLabel: locale.see_all,
              ),
              const SizedBox(height: Spacing.sm),
              const _OfflineExploreMoreSection(),
            ],
          );
        }

        final items = section?.items ?? const <ProductModel>[];
        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            SectionHeader(
              title: locale.section_explore,
              actionLabel: locale.see_all,
            ),
            const SizedBox(height: Spacing.sm),
            ...items.map(
              (product) => ExploreMoreTile(
                product: product,
                addToCartLabel: locale.add_to_cart,
                onTap: () {
                  ProductNavigationHelper.navigateToProductDetails(
                    context,
                    product,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ExploreMoreListSkeleton extends StatelessWidget {
  const _ExploreMoreListSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _ExploreMoreTileSkeleton(),
        SizedBox(height: Spacing.xs),
        _ExploreMoreTileSkeleton(),
        SizedBox(height: Spacing.xs),
        _ExploreMoreTileSkeleton(),
      ],
    );
  }
}

class _ExploreMoreTileSkeleton extends StatelessWidget {
  const _ExploreMoreTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(
          color: context.colorScheme.outline.withValues(alpha: 0.12),
        ),
      ),
      child: const Row(
        children: [
          Bone(width: 72, height: 72, radius: Spacing.cardRadius),
          SizedBox(width: Spacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone(width: 140, height: 14, radius: 999),
                SizedBox(height: Spacing.xs),
                Bone(width: 100, height: 12, radius: 999),
                SizedBox(height: Spacing.sm),
                Bone(width: 80, height: 12, radius: 999),
              ],
            ),
          ),
          SizedBox(width: Spacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Bone(width: 18, height: 18, radius: 999),
              SizedBox(height: Spacing.sm),
              Bone(width: 58, height: 28, radius: Spacing.sm),
            ],
          ),
        ],
      ),
    );
  }
}

class _OfflineExploreMoreSection extends StatelessWidget {
  const _OfflineExploreMoreSection();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.lg,
        ),
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.outline.withValues(alpha: 0.15)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 34, color: color.primary),
            const SizedBox(height: Spacing.sm),
            Text(
              locale.explore_more_unavailable,
              style: getSemiBoldStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: color.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
