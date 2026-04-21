import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/layout/home_section_card_layout.dart';
import 'package:zadana_user_v3/core/utils/home_product_cart_helper.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_product_card.dart';
import 'package:zadana_user_v3/feature/best_selling/presentation/pages/best_selling_products_page.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_view_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_loading_skeleton.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/section_header.dart';

class BestSellingSection extends StatelessWidget {
  const BestSellingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = HomeSectionCardLayout.classicCardWidth(viewportWidth);
    final sectionHeight = HomeSectionCardLayout.classicSectionHeight(
      viewportWidth,
    );

    return BlocBuilder<HomeViewModel, HomeState>(
      buildWhen: (previous, current) =>
          previous.bestSellingSection != current.bestSellingSection,
      builder: (context, state) {
        if (state.bestSellingSection.isLoading) {
          return Column(
            children: [
              SectionHeader(
                title: locale.section_best_selling,
                actionLabel: locale.see_all,
                onActionTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BestSellingProductsPage(
                        title: locale.section_best_selling,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: Spacing.md),
              SizedBox(
                height: sectionHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.screenH,
                  ),
                  child: ShimmerEffect(
                    child: _BestSellingItemsSkeleton(cardWidth: cardWidth),
                  ),
                ),
              ),
            ],
          );
        }

        final section = state.bestSellingSection.data;
        if (section?.isActive == false) {
          return const SizedBox.shrink();
        }

        if (state.bestSellingSection.failure != null &&
            state.bestSellingSection.data == null) {
          return const SizedBox.shrink();
        }

        final items = section?.items ?? const <ProductModel>[];
        if (items.isEmpty) {
          return const SizedBox.shrink();
        }
        final visibleItems = items.take(5).toList(growable: false);

        return Column(
          children: [
            SectionHeader(
              title: locale.section_best_selling,
              actionLabel: locale.see_all,
              onActionTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BestSellingProductsPage(
                      title: locale.section_best_selling,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: Spacing.md),
            SizedBox(
              height: sectionHeight,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.screenH,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: visibleItems.length,
                separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
                itemBuilder: (_, i) {
                  final product = visibleItems[i];
                  final heroTag = productHeroTag(
                    product.id,
                    source: 'home-best-selling',
                  );
                  return SizedBox(
                    width: cardWidth,
                    child: CustomProductCard(
                      discountPercentage: product.discountPercentage,
                      isDiscounted: product.isDiscounted,
                      product: product,
                      heroTag: heroTag,
                      showFavorite: true,
                      onAddTap: () => HomeProductCartHelper.addProductToCart(
                        context,
                        product,
                      ),
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
            ),
          ],
        );
      },
    );
  }
}

class _BestSellingItemsSkeleton extends StatelessWidget {
  const _BestSellingItemsSkeleton({required this.cardWidth});

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
