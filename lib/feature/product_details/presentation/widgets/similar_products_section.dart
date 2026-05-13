import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_product_card.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class SimilarProductsSection extends StatelessWidget {
  const SimilarProductsSection({
    super.key,
    required this.similarProducts,
    this.onProductTap,
    this.onAddToCart,
    this.activeProductId,
  });

  final List<ProductModel> similarProducts;
  final Function(ProductModel)? onProductTap;
  final Future<void> Function(ProductModel)? onAddToCart;
  final String? activeProductId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final color = context.colorScheme;

    if (similarProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      color: color.surface,
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.similar_products,
            style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  color: color.onSurfaceVariant,fontSize: FontSize.size15,
                ),
          ),
          const SizedBox(height: Spacing.sm),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: similarProducts.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: Spacing.sm),
              itemBuilder: (context, index) {
                final product = similarProducts[index];
                return SizedBox(
                  width: 130,
                  child: CustomProductCard(
                    discountPercentage: product.discountPercentage,
                    isDiscounted: product.isDiscounted,
                    product: product,
                    onCardTap: () => onProductTap?.call(product),
                    onAddTap: () async => onAddToCart?.call(product),
                    showFavorite: true,
                    enableHeroAnimation: activeProductId == product.id,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
