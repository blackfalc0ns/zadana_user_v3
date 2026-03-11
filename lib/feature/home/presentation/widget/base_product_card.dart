import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/price_text.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/product_image.dart';

/// Base card widget for Special Offers, Best Selling, and Featured Products
/// - Favorite button at top right
/// - Cart/Add button at bottom right
/// - Consistent styling and spacing
class BaseProductCard extends StatelessWidget {
  const BaseProductCard({
    super.key,
    required this.product,
    this.width = 150,
    this.imageHeight = 90,
    this.showFavorite = false,
    this.showCartButton = true,
    this.onAddTap,
    this.onFavoriteTap,
    this.onCardTap,
  });

  final ProductModel product;
  final double width;
  final double imageHeight;
  final bool showFavorite;
  final bool showCartButton;
  final VoidCallback? onAddTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onCardTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with optional favorite button
            Stack(
              children: [
                ProductImage(
                  emoji: product.emoji,
                  url: product.imageUrl,
                  width: width,
                  height: imageHeight,
                  borderRadius: Spacing.cardRadius,
                ),
                if (showFavorite)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Icon(
                          product.isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 16,
                          color: product.isFavorite
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(Spacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product.store,
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PriceText(
                        price: product.price,
                        unit: product.unit,
                      ),
                      if (showCartButton)
                        GestureDetector(
                          onTap: onAddTap,
                          child: Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const FaIcon(
                              FontAwesomeIcons.cartPlus,
                              color: AppColors.white,
                              size: 15,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
