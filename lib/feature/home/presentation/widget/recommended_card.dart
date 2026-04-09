import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/price_text.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/core/widgets/product_image.dart';

class RecommendedCard extends StatelessWidget {
  const RecommendedCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteTap,
  });

  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final cardWidth = (MediaQuery.sizeOf(context).width / 2.4).clamp(
      140.0,
      200.0,
    );

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: cardWidth,
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(Spacing.cardRadius),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Image ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(
                    right: 8,
                  ), // إضافة مساحة من اليمين
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Spacing.cardRadius),
                    child: ProductImage(
                      emoji: product.emoji,
                      url: product.imageUrl,
                      width: 48,
                      height: 48,
                      borderRadius: Spacing.cardRadius,
                      heroTag: productHeroTag(product.id),
                    ),
                  ),
                ),

                // ── Text ──────────────────────────────────────────────
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.name,
                        style: AppTextStyles.labelMedium.copyWith(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: PriceText(
                              price: product.price,
                              oldPrice: product.oldPrice,
                              compact: true,
                            ),
                          ),
                          const SizedBox(width: Spacing.xs),
                          Container(
                            padding: const EdgeInsets.all(Spacing.xs),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: FaIcon(
                              FontAwesomeIcons.cartPlus,
                              color: AppColors.white,
                              size: 14,
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

          // ── Favorite Icon ─────────────────────────────────────────
          if (onFavoriteTap != null)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: onFavoriteTap,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: AppColors.shadow, blurRadius: 0.5),
                    ],
                  ),
                  child: Icon(
                    product.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 16,
                    color: product.isFavorite
                        ? AppColors.error
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
