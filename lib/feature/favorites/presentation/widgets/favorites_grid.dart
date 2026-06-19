import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/layout/product_grid_layout.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_product_card.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class FavoritesGrid extends StatefulWidget {
  const FavoritesGrid({
    super.key,
    required this.products,
    required this.onAddToCart,
    required this.onToggleFavorite,
    required this.onLoadMore,
    this.isLoadingMore = false,
    this.hasMore = false,
  });
  final List<ProductModel> products;
  final Future<void> Function(ProductModel) onAddToCart;
  final Future<void> Function(ProductModel) onToggleFavorite;
  final VoidCallback onLoadMore;
  final bool isLoadingMore;
  final bool hasMore;

  @override
  State<FavoritesGrid> createState() => _FavoritesGridState();
}

class _FavoritesGridState extends State<FavoritesGrid> {
  static const double _loadMoreThreshold = 320;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    if (position.extentAfter <= _loadMoreThreshold &&
        widget.hasMore &&
        !widget.isLoadingMore) {
      widget.onLoadMore();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = ProductGridLayout.resolve(
          constraints.maxWidth,
          horizontalPadding: 0,
          crossAxisSpacing: Spacing.sm,
        );

        final itemCount = widget.products.length +
            (widget.isLoadingMore ? layout.crossAxisCount : 0);

        return GridView.builder(
          controller: _scrollController,
          key: const PageStorageKey<String>('favorites_products_grid'),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: layout.crossAxisCount,
            childAspectRatio: layout.childAspectRatio,
            crossAxisSpacing: Spacing.sm,
            mainAxisSpacing: Spacing.sm,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (index >= widget.products.length) {
              return const _LoadingPlaceholder();
            }

            final product = widget.products[index];
            final heroTag = productHeroTag(
              product.id,
              source: 'favorites-grid',
            );
            return CustomProductCard(
              discountPercentage: product.discountPercentage,
              isDiscounted: product.isDiscounted,
              product: product,
              heroTag: heroTag,
              showFavorite: true,
              onCardTap: () {
                ProductNavigationHelper.navigateToProductDetails(
                  context,
                  product,
                  heroTag: heroTag,
                );
              },
              onAddTap: () => widget.onAddToCart(product),
              onFavoriteTap: () => widget.onToggleFavorite(product),
            );
          },
        );
      },
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
