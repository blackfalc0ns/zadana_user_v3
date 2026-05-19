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
import 'package:zadana_user_v3/feature/featured/presentation/pages/featured_products_page.dart';
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
    final globalCubit = context.read<AppSectionGlobalCubit>();
    final sectionHeight = HomeSectionCardLayout.featuredSectionHeight(
      MediaQuery.sizeOf(context).width,
    );

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
                onActionTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: globalCubit,
                        child: FeaturedProductsPage(
                          title: locale.section_featured,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: Spacing.md),
              SizedBox(
                height: sectionHeight,
                child: const Padding(
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
          return const SizedBox.shrink();
        }

        final items = section?.items ?? const <ProductModel>[];
        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        // Calculate dynamic cross axis count based on item count
        final needsTwoRows = items.length > 2;
        final crossAxisCount = needsTwoRows ? 2 : 1;
        final dynamicHeight = needsTwoRows
            ? sectionHeight
            : sectionHeight / 2;

        return Padding(
          padding: const EdgeInsets.only(top:  Spacing.lg),
          child: Column(
            children: [
              SectionHeader(
                title: locale.section_featured,
                actionLabel: locale.see_all,
                onActionTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: globalCubit,
                        child: FeaturedProductsPage(
                          title: locale.section_featured,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: Spacing.md),
              SizedBox(
                height: dynamicHeight,
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.screenH,
                  ),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
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
                      onCardTap: () =>
                          ProductNavigationHelper.navigateToProductDetails(
                            context,
                            product,
                            heroTag: heroTag,
                          ),
                    );
                  },
                ),
              ),
            ],
          ),
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
