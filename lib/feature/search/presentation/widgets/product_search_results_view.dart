import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/empty_state_widget.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/layout/product_grid_layout.dart';
import 'package:zadana_user_v3/core/utils/home_product_cart_helper.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_product_card.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_loading_skeleton.dart'
    show ShimmerEffect;
import 'package:zadana_user_v3/feature/search/presentation/manager/product_search_cubit.dart';
import 'package:zadana_user_v3/feature/search/presentation/manager/product_search_state.dart';

class ProductSearchResultsView extends StatelessWidget {
  const ProductSearchResultsView({
    super.key,
    required this.scrollController,
    required this.onRetry,
    required this.onRefresh,
  });

  final ScrollController scrollController;
  final VoidCallback onRetry;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductSearchViewModel, ProductSearchState>(
      builder: (context, state) {
        final l10n = context.localization;

        if (!state.hasQuery) return const _SearchPromptState();
        if (state.isLoading && state.items.isEmpty) {
          return const _ProductsLoadingGrid();
        }
        if (state.failure != null && state.items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ApiErrorWidget(
                  exception: state.failure!.exception,
                  onRetry: onRetry,
                ),
            ),
          );
        }
        if (state.items.isEmpty) {
          return EmptyStateWidget(
            title: l10n.search_empty_title,
            description: l10n.search_empty_description,
            icon: Icons.search_off_rounded,
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final layout = ProductGridLayout.resolve(constraints.maxWidth);

            return RefreshIndicator(
              onRefresh: onRefresh,
              child: GridView.builder(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                  top: 4,
                  left: Spacing.md,
                  right: Spacing.md,
                  bottom: 85,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: layout.crossAxisCount,
                  childAspectRatio: layout.childAspectRatio,
                  crossAxisSpacing: Spacing.xss,
                  mainAxisSpacing: Spacing.xss,
                ),
                itemCount: state.items.length + (state.isLoadingMore ? 3 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.items.length) {
                    return _ProductCardSkeleton(index: index);
                  }

                  final product = state.items[index];
                  final heroTag = productHeroTag(
                    product.id,
                    source: 'search-grid',
                  );

                  return CustomProductCard(
                    discountPercentage: product.discountPercentage,
                    isDiscounted: product.isDiscounted,
                    product: product,
                    heroTag: heroTag,
                    showFavorite: true,
                    onCardTap: () =>
                        ProductNavigationHelper.navigateToProductDetails(
                          context,
                          product,
                          heroTag: heroTag,
                        ),
                    onAddTap: () => HomeProductCartHelper.addProductToCart(
                      context,
                      product,
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _SearchPromptState extends StatelessWidget {
  const _SearchPromptState();

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: EmptyStateWidget(
          title: l10n.search_start_title,
          description: l10n.search_start_description,
          icon: Icons.search_rounded,
        ),
      ),
    );
  }
}

class _ProductsLoadingGrid extends StatelessWidget {
  const _ProductsLoadingGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = ProductGridLayout.resolve(constraints.maxWidth);

        return ShimmerEffect(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(
              top: 4,
              left: Spacing.md,
              right: Spacing.md,
              bottom: 85,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: layout.crossAxisCount,
              childAspectRatio: layout.childAspectRatio,
              crossAxisSpacing: Spacing.xss,
              mainAxisSpacing: Spacing.xss,
            ),
            itemCount: 15,
            itemBuilder: (_, index) => _ProductCardSkeleton(index: index),
          ),
        );
      },
    );
  }
}

class _ProductCardSkeleton extends StatelessWidget {
  const _ProductCardSkeleton({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardHeight = constraints.maxHeight;
        final imageHeight = (cardHeight * 0.46).clamp(52.0, 75.0).toDouble();
        final favoriteSize = (cardHeight * 0.17).clamp(24.0, 28.0).toDouble();
        final cartSize = (cardHeight * 0.17).clamp(24.0, 28.0).toDouble();
        final titleHeight = (cardHeight * 0.07).clamp(10.0, 12.0).toDouble();
        final metaHeight = (cardHeight * 0.06).clamp(8.0, 10.0).toDouble();
        final spacing = (cardHeight * 0.025).clamp(2.0, 4.0).toDouble();
        final horizontalPadding = (constraints.maxWidth * 0.08)
            .clamp(6.0, 8.0)
            .toDouble();
        final bottomPadding = (cardHeight * 0.02).clamp(2.0, 4.0).toDouble();

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(Spacing.cardRadius),
            border: Border.all(color: AppColors.border),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Bone(height: imageHeight, radius: Spacing.cardRadius),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        spacing * 1.5,
                        horizontalPadding,
                        bottomPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Bone(
                            width: switch (index % 4) {
                              0 => 72,
                              1 => 64,
                              2 => 78,
                              _ => 68,
                            },
                            height: titleHeight,
                            radius: 999,
                          ),
                          const Spacer(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _Bone(
                                      width: 40,
                                      height: metaHeight,
                                      radius: 999,
                                    ),
                                    SizedBox(height: spacing),
                                    _Bone(
                                      width: 32,
                                      height: metaHeight,
                                      radius: 999,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: spacing),
                              _Bone(
                                width: cartSize,
                                height: cartSize,
                                radius: 999,
                              ),
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
                child: _Bone(
                  width: favoriteSize,
                  height: favoriteSize,
                  radius: 999,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Bone extends StatelessWidget {
  const _Bone({this.width, required this.height, required this.radius});

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
