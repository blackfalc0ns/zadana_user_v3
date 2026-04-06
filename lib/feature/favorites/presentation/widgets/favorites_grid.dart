import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/layout/product_grid_layout.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_product_card.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class FavoritesGrid extends StatelessWidget {
  final List<ProductModel> products;
  final Function(ProductModel) onAddToCart;
  final Function(ProductModel) onToggleFavorite;

  const FavoritesGrid({
    super.key,
    required this.products,
    required this.onAddToCart,
    required this.onToggleFavorite,
  });

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
            return CustomProductCard(
              discountPercentage: index * 12,
              isDiscounted: index % 2 == 0,
              product: product,
              showFavorite: true,
              onCardTap: () {
                ProductNavigationHelper.navigateToProductDetails(
                  context,
                  product,
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
