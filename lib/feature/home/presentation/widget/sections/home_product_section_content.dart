import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/layout/home_section_card_layout.dart';
import 'package:zadana_user_v3/core/utils/home_product_cart_helper.dart';
import 'package:zadana_user_v3/core/utils/home_product_section_theme.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_product_card.dart';
import 'package:zadana_user_v3/core/widgets/recommended_product_card.dart';
import 'package:zadana_user_v3/core/widgets/showcase_product_card.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_loading_skeleton.dart';

class HomeProductSectionContent extends StatelessWidget {
  const HomeProductSectionContent({
    super.key,
    required this.items,
    required this.theme,
    required this.heroSource,
  });

  final List<ProductModel> items;
  final String? theme;
  final String heroSource;

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final classicWidth = HomeSectionCardLayout.classicCardWidth(viewportWidth);
    final classicHeight = HomeSectionCardLayout.classicSectionHeight(
      viewportWidth,
    );
    final compactWidth = HomeSectionCardLayout.compactCardWidth(viewportWidth);
    final compactHeight = HomeSectionCardLayout.compactSectionHeight(
      viewportWidth,
    );

    switch (parseHomeProductSectionTheme(theme)) {
      case HomeProductSectionTheme.classic:
        return SizedBox(
          height: classicHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
            itemBuilder: (_, i) {
              final product = items[i];
              final heroTag = productHeroTag(product.id, source: heroSource);
              return SizedBox(
                width: classicWidth,
                child: CustomProductCard(
                  discountPercentage: product.discountPercentage,
                  isDiscounted: product.isDiscounted,
                  product: product,
                  heroTag: heroTag,
                  showFavorite: true,
                  onAddTap: () =>
                      HomeProductCartHelper.addProductToCart(context, product),
                  onCardTap: () =>
                      ProductNavigationHelper.navigateToProductDetails(
                        context,
                        product,
                        heroTag: heroTag,
                      ),
                ),
              );
            },
          ),
        );
      case HomeProductSectionTheme.compact:
        return SizedBox(
          height: compactHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
            itemBuilder: (_, i) {
              final product = items[i];
              final heroTag = productHeroTag(product.id, source: heroSource);
              return RecommendedProductCard(
                product: product,
                heroTag: heroTag,
                cardWidth: compactWidth,
                minHeight: compactHeight,
                onTap: () => ProductNavigationHelper.navigateToProductDetails(
                  context,
                  product,
                  heroTag: heroTag,
                ),
                onAddTap: () =>
                    HomeProductCartHelper.addProductToCart(context, product),
              );
            },
          ),
        );
      case HomeProductSectionTheme.showcase:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
          child: LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 8.0;
              final itemWidth = (constraints.maxWidth - spacing) / 2;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final product in items)
                    SizedBox(
                      width: itemWidth,
                      child: ShowcaseProductCard(
                        product: product,
                        heroTag: productHeroTag(product.id, source: heroSource),
                        onTap: () =>
                            ProductNavigationHelper.navigateToProductDetails(
                              context,
                              product,
                              heroTag: productHeroTag(
                                product.id,
                                source: heroSource,
                              ),
                            ),
                        onAddTap: () => HomeProductCartHelper.addProductToCart(
                          context,
                          product,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
    }
  }
}

class HomeProductSectionSkeleton extends StatelessWidget {
  const HomeProductSectionSkeleton({super.key, required this.theme});

  final String? theme;

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final classicWidth = HomeSectionCardLayout.classicCardWidth(viewportWidth);
    final classicHeight = HomeSectionCardLayout.classicSectionHeight(
      viewportWidth,
    );
    final compactWidth = HomeSectionCardLayout.compactCardWidth(viewportWidth);
    final compactHeight = HomeSectionCardLayout.compactSectionHeight(
      viewportWidth,
    );

    switch (parseHomeProductSectionTheme(theme)) {
      case HomeProductSectionTheme.classic:
        return SizedBox(
          height: classicHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
            child: _ClassicSectionSkeleton(cardWidth: classicWidth),
          ),
        );
      case HomeProductSectionTheme.compact:
        return SizedBox(
          height: compactHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
            child: _CompactSectionSkeleton(cardWidth: compactWidth),
          ),
        );
      case HomeProductSectionTheme.showcase:
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: Spacing.screenH),
          child: _ShowcaseSectionSkeleton(),
        );
    }
  }
}

class _ClassicSectionSkeleton extends StatelessWidget {
  const _ClassicSectionSkeleton({required this.cardWidth});

  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
      itemBuilder: (_, _) => ProductCardSkeleton(width: cardWidth),
    );
  }
}

class _CompactSectionSkeleton extends StatelessWidget {
  const _CompactSectionSkeleton({required this.cardWidth});

  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
      itemBuilder: (_, _) {
        return Container(
          width: cardWidth,
          padding: const EdgeInsets.all(Spacing.sm),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(Spacing.cardRadius),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: .2),
            ),
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
      },
    );
  }
}

class _ShowcaseSectionSkeleton extends StatelessWidget {
  const _ShowcaseSectionSkeleton();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        final itemWidth = (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(
            6,
            (_) => SizedBox(
              width: itemWidth,
              child: Container(
                height: 82,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                padding: const EdgeInsets.all(4),
                child: const Row(
                  children: [
                    Bone(width: 34, height: 66, radius: 10),
                    SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Bone(height: 9, radius: 999),
                          Spacer(),
                          Bone(width: 34, height: 8, radius: 999),
                          SizedBox(height: 4),
                          Bone(height: 18, radius: 6),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
