import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/widgets/custom_product_card.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class SimilarProductsSection extends StatelessWidget {
  final List<ProductModel> similarProducts;
  final Function(ProductModel)? onProductTap;
  final Function(ProductModel)? onAddToCart;
  final String? activeProductId;

  const SimilarProductsSection({
    super.key,
    required this.similarProducts,
    this.onProductTap,
    this.onAddToCart,
    this.activeProductId,
  });

  @override
  Widget build(BuildContext context) {
    if (similarProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(Spacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'منتجات مشابهة',
            style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
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
                    onAddTap: () => onAddToCart?.call(product),
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
