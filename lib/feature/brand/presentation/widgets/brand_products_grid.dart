import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/layout/product_grid_layout.dart';
import 'package:zadana_user_v3/core/utils/home_product_cart_helper.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_product_card.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_product_model.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class BrandProductsGrid extends StatelessWidget {
  const BrandProductsGrid({super.key, required this.products});

  final List<BrandProductModel> products;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final layout = ProductGridLayout.resolve(
          constraints.crossAxisExtent,
          horizontalPadding: Spacing.md * 2,
          crossAxisSpacing: Spacing.xs,
        );

        return SliverPadding(
          padding: const EdgeInsets.all(Spacing.md),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: layout.crossAxisCount,
              childAspectRatio: layout.childAspectRatio,
              crossAxisSpacing: Spacing.xs,
              mainAxisSpacing: Spacing.xs,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final brandProduct = products[index];
              final heroTag = productHeroTag(
                brandProduct.id,
                source: 'brand-grid',
              );
              final product = ProductModel(
                id: brandProduct.id,
                name: brandProduct.name,
                store: brandProduct.brandName,
                price: brandProduct.price,
                oldPrice: brandProduct.oldPrice,
                imageUrl: brandProduct.imageUrl,
                emoji: brandProduct.emoji,
                discount: brandProduct.discount,
                isFavorite: brandProduct.isFavorite,
                unit: brandProduct.unit,
                isDiscounted:
                    brandProduct.hasDiscount ||
                    ((brandProduct.oldPrice ?? 0) > brandProduct.price),
              );

              return CustomProductCard(
                discountPercentage: product.discountPercentage,
                isDiscounted: product.isDiscounted,
                heroTag: heroTag,
                product: product,
                showFavorite: true,
                onCardTap: () {
                  ProductNavigationHelper.navigateToProductDetails(
                    context,
                    product,
                    heroTag: heroTag,
                  );
                },
                onAddTap: brandProduct.isInStock
                    ? () => HomeProductCartHelper.addProductToCart(
                        context,
                        product,
                      )
                    : null,
              );
            }, childCount: products.length),
          ),
        );
      },
    );
  }
}
