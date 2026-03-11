import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/price_text.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/product_image.dart';

class BaseProductCard extends StatelessWidget {
  const BaseProductCard({
    super.key,
    required this.product,
    this.onAddTap,
    this.onCardTap,
    this.onFavoriteTap,
    this.width = 150,
    this.imageHeight = 90,
    this.showFavorite = false,
  });

  final ProductModel product;
  final VoidCallback? onAddTap;
  final VoidCallback? onCardTap;
  final VoidCallback? onFavoriteTap;
  final double width;
  final double imageHeight;
  final bool showFavorite;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 190, // ارتفاع ثابت للكارد
      child: GestureDetector(
        onTap: onCardTap,
        child: Container(
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
                  // ── Image ────────────────────────────────────────────
                  ProductImage(
                    emoji: product.emoji,
                    url: product.imageUrl,
                    width: width,
                    height: imageHeight,
                    borderRadius: Spacing.cardRadius,
                  ),

                  // ── Info ─────────────────────────────────────────────
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        Spacing.sm,
                        Spacing.sm,
                        Spacing.sm,
                        Spacing.sm,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
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
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PriceText(price: product.price, unit: product.unit),
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
                                  child: FaIcon(
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
                  ),
                ],
              ),
              
              // ── Favorite Button ──────────────────────────────────
              if (showFavorite)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        product.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 14,
                        color: product.isFavorite
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
             