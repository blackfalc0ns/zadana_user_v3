import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/layout/home_section_card_layout.dart';
import 'package:zadana_user_v3/core/utils/home_product_cart_helper.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_product_card.dart';
import 'package:zadana_user_v3/feature/app_section/manager/app_section_global_cubit.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_view_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_loading_skeleton.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/section_header.dart';
import 'package:zadana_user_v3/feature/special_offers/presentation/pages/special_offers_products_page.dart';

class SpecialOffersSection extends StatelessWidget {
  const SpecialOffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final globalCubit = context.read<AppSectionGlobalCubit>();
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = HomeSectionCardLayout.classicCardWidth(viewportWidth);
    final sectionHeight = HomeSectionCardLayout.classicSectionHeight(
      viewportWidth,
    );

    return BlocBuilder<HomeViewModel, HomeState>(
      buildWhen: (previous, current) =>
          previous.specialOffersSection != current.specialOffersSection,
      builder: (context, state) {
        if (state.specialOffersSection.isLoading) {
          return Column(
            children: [
              SectionHeader(
                title: locale.section_special_offers,
                actionLabel: locale.see_all,
                onActionTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: globalCubit,
                        child: SpecialOffersProductsPage(
                          title: locale.section_special_offers,
                        ),
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
                    child: _SpecialOffersItemsSkeleton(cardWidth: cardWidth),
                  ),
                ),
              ),
            ],
          );
        }

        final section = state.specialOffersSection.data;
        if (section?.isActive == false) {
          return const SizedBox.shrink();
        }

        if (state.specialOffersSection.failure != null &&
            state.specialOffersSection.data == null) {
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
              title: locale.section_special_offers,
              actionLabel: locale.see_all,
              onActionTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: globalCubit,
                      child: SpecialOffersProductsPage(
                        title: locale.section_special_offers,
                      ),
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
                    source: 'home-special-offers',
                  );
                  return SizedBox(
                    width: cardWidth,
                    child: CustomProductCard(
                      product: product,
                      showFavorite: true,
                      heroTag: heroTag,
                      discountPercentage: product.discountPercentage,
                      isDiscounted: product.isDiscounted,
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

class _SpecialOffersItemsSkeleton extends StatelessWidget {
  const _SpecialOffersItemsSkeleton({required this.cardWidth});

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
