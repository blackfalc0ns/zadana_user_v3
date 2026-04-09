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
import 'package:zadana_user_v3/feature/home/presentation/widget/home_loading_skeleton.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/recommended_card.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/section_header.dart';

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocBuilder<HomeViewModel, HomeState>(
      buildWhen: (previous, current) =>
          previous.recommendedSection != current.recommendedSection,
      builder: (context, state) {
        if (state.recommendedSection.isLoading) {
          return Column(
            children: [
              SectionHeader(
                title: locale.section_recommended,
                actionLabel: locale.refresh,
              ),
              const SizedBox(height: Spacing.sm),
              const SizedBox(
                height: 66,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Spacing.screenH),
                  child: ShimmerEffect(child: _RecommendedItemsSkeleton()),
                ),
              ),
            ],
          );
        }

        final section = state.recommendedSection.data;
        if (section?.isActive == false) {
          return const SizedBox.shrink();
        }

        if (state.recommendedSection.failure != null &&
            state.recommendedSection.data == null) {
          return Column(
            children: [
              SectionHeader(
                title: locale.section_recommended,
                actionLabel: locale.refresh,
              ),
              const SizedBox(height: Spacing.sm),
              const _OfflineRecommendedSection(),
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
              title: locale.section_recommended,
              actionLabel: locale.refresh,
            ),
            const SizedBox(height: Spacing.sm),
            SizedBox(
              height: 66,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
                itemBuilder: (_, i) {
                  final product = items[i];
                  return RecommendedCard(
                    product: product,
                    onTap: () {
                      ProductNavigationHelper.navigateToProductDetails(
                        context,
                        product,
                      );
                    },
                    onFavoriteTap: () {},
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

class _RecommendedItemsSkeleton extends StatelessWidget {
  const _RecommendedItemsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
      itemBuilder: (_, _) => const _RecommendedCardSkeleton(),
    );
  }
}

class _RecommendedCardSkeleton extends StatelessWidget {
  const _RecommendedCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final cardWidth = (MediaQuery.sizeOf(context).width / 2.4).clamp(
      140.0,
      200.0,
    );

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: context.colorScheme.outline.withValues(alpha: .2)),
      ),
      child: const Row(
        children: [
          Bone(width: 48, height: 48, radius: Spacing.cardRadius),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone(width: 70, height: 10, radius: 999),
                SizedBox(height: 8),
                Bone(width: 55, height: 10, radius: 999),
              ],
            ),
          ),
          SizedBox(width: 8),
          Bone(width: 24, height: 24, radius: 6),
        ],
      ),
    );
  }
}

class _OfflineRecommendedSection extends StatelessWidget {
  const _OfflineRecommendedSection();

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
              locale.recommended_unavailable,
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
