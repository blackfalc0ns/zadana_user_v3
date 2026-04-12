import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/utils/home_product_cart_helper.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_product_card.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_view_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_loading_skeleton.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/section_header.dart';

class FeaturedProductsSection extends StatelessWidget {
  const FeaturedProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocBuilder<HomeViewModel, HomeState>(
      buildWhen: (previous, current) =>
          previous.featuredSection != current.featuredSection,
      builder: (context, state) {
        if (state.featuredSection.isLoading) {
          return Column(
            children: [
              SectionHeader(
                title: locale.section_featured,
                actionLabel: locale.see_all,
              ),
              const SizedBox(height: Spacing.md),
              const SizedBox(
                height: 285,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Spacing.screenH),
                  child: ShimmerEffect(child: _FeaturedGridSkeleton()),
                ),
              ),
            ],
          );
        }

        final section = state.featuredSection.data;
        if (section?.isActive == false) {
          return const SizedBox.shrink();
        }

        if (state.featuredSection.failure != null &&
            state.featuredSection.data == null) {
          return Column(
            children: [
              SectionHeader(
                title: locale.section_featured,
                actionLabel: locale.see_all,
              ),
              const SizedBox(height: Spacing.md),
              const _OfflineFeaturedSection(),
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
              title: locale.section_featured,
              actionLabel: locale.see_all,
            ),
            const SizedBox(height: Spacing.md),
            SizedBox(
              height: 285,
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: Spacing.sm,
                  mainAxisSpacing: Spacing.sm,
                  childAspectRatio: 1.1,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final product = items[index];
                  final heroTag = productHeroTag(
                    product.id,
                    source: 'home-featured',
                  );
                  return CustomProductCard(
                    discountPercentage: product.discountPercentage,
                    isDiscounted: product.isDiscounted,
                    product: product,
                    heroTag: heroTag,
                    showFavorite: true,
                    onAddTap: () => HomeProductCartHelper.addProductToCart(
                      context,
                      product,
                    ),
                    onCardTap: () => ProductNavigationHelper
                        .navigateToProductDetails(
                          context,
                          product,
                          heroTag: heroTag,
                        ),
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

class _FeaturedGridSkeleton extends StatelessWidget {
  const _FeaturedGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Spacing.sm,
        mainAxisSpacing: Spacing.sm,
        childAspectRatio: 1.1,
      ),
      itemCount: 4,
      itemBuilder: (_, _) => const ProductCardSkeleton(),
    );
  }
}

class _OfflineFeaturedSection extends StatelessWidget {
  const _OfflineFeaturedSection();

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
              locale.featured_unavailable,
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
