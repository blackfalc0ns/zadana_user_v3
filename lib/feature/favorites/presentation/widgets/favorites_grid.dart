import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/layout/product_grid_layout.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_product_card.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class FavoritesGrid extends StatelessWidget {
  const FavoritesGrid({
    super.key,
    required this.products,
    required this.onAddToCart,
    required this.onToggleFavorite,
  });
  final List<ProductModel> products;
  final Future<void> Function(ProductModel) onAddToCart;
  final Future<void> Function(ProductModel) onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = ProductGridLayout.resolve(
          constraints.maxWidth,
          horizontalPadding: 0,
          crossAxisSpacing: Spacing.sm,
        );

        return GridView.builder(
          key: const PageStorageKey<String>('favorites_products_grid'),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: layout.crossAxisCount,
            childAspectRatio: layout.childAspectRatio,
            crossAxisSpacing: Spacing.sm,
            mainAxisSpacing: Spacing.sm,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
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
              onAddTap: () => onAddToCart(product),
              onFavoriteTap: () => onToggleFavorite(product),
            );
          },
        );
      },
    );
  }
}
