import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/widgets/custom_product_card.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_product_model.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class BrandProductsGrid extends StatelessWidget {
  const BrandProductsGrid({
    super.key,
    required this.products,
  });

  final List<BrandProductModel> products;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(Spacing.md),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.85,
          crossAxisSpacing: Spacing.xs,
          mainAxisSpacing: Spacing.xs,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final brandProduct = products[index];
            return CustomProductCard(
              product: ProductModel(
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
              ),
              showFavorite: true,
              onCardTap: () {},
              onAddTap: brandProduct.isInStock ? () {} : null,
              onFavoriteTap: () {},
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }
}