import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
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
    return GridView.builder(
      key: const PageStorageKey<String>('favorites_products_grid'),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // تغيير من 2 إلى 3 عناصر في الصف
        childAspectRatio: 0.75, // نسبة أفضل للـ CompactProductCard
        crossAxisSpacing: Spacing.sm,
        mainAxisSpacing: Spacing.sm,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return CustomProductCard(
          product: product,
          showFavorite: true,
          onCardTap: () {
            ProductNavigationHelper.navigateToProductDetails(context, product);
          },
          onAddTap: () => onAddToCart(product),
          onFavoriteTap: () => onToggleFavorite(product),
        );
      },
    );
  }
}
